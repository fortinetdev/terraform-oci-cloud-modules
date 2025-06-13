# Local variables to get the Marketplace listing ID based on product_name
locals {
  mp_listing_id = (
    var.product_name == "fortigate"
    ? var.mp_listing_id
    : (
      contains(["fortiaiops", "fortiguest", "fortimanager", "fortianalyzer"], var.product_name)
      ? lookup(
        jsondecode(file("${path.module}/source_id_maps/${var.product_name}_source_id_map.json"))[var.image_version],
        "mp_listing_id",
        null
      )
      : null
    )
  )
  mp_listing_resource_version = (
    var.product_name == "fortigate"
    ? var.listing_resource_version
    : (
      contains(["fortiaiops", "fortiguest", "fortimanager", "fortianalyzer"], var.product_name)
      ? lookup(
        jsondecode(file("${path.module}/source_id_maps/${var.product_name}_source_id_map.json"))[var.image_version],
        "listing_resource_version",
        null
      )
      : null
    )
  )
}

# Fetch Availability Domains
# This data source retrieves the list of availability domains in the specified tenancy.
# It is used to determine the availability domain for resources like subnets and instances.
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Create VCN
resource "oci_core_virtual_network" "vcn" {
  cidr_blocks    = var.vcn_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "${var.product_name}-vcn"
  dns_label      = "fortivcn"
  freeform_tags  = var.tag
}

# Create Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.product_name}-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
  freeform_tags  = var.tag
}

# Create Route Table
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.product_name}-public-rt"
  freeform_tags  = var.tag

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Create Security List
resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = var.custom_security_list_rules.display_name
  freeform_tags  = var.tag

  dynamic "egress_security_rules" {
    for_each = var.custom_security_list_rules.egress_security_rules
    content {
      destination = egress_security_rules.value.destination
      protocol    = egress_security_rules.value.protocol
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.custom_security_list_rules.ingress_security_rules
    content {
      protocol  = ingress_security_rules.value.protocol
      source    = ingress_security_rules.value.source
      stateless = lookup(ingress_security_rules.value, "stateless", false)

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.tcp_options == null ? [] : [ingress_security_rules.value.tcp_options]
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }

      dynamic "udp_options" {
        for_each = ingress_security_rules.value.udp_options == null ? [] : [ingress_security_rules.value.udp_options]
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }

      dynamic "icmp_options" {
        for_each = ingress_security_rules.value.icmp_options == null ? [] : [ingress_security_rules.value.icmp_options]
        content {
          type = icmp_options.value.type
          code = icmp_options.value.code
        }
      }
    }
  }
}

# Create Subnet
resource "oci_core_subnet" "public_subnet" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1].name
  cidr_block          = var.public_subnet_cidr
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn.id
  display_name        = "${var.product_name}-subnet"
  route_table_id      = oci_core_route_table.public_rt.id
  security_list_ids = [
    oci_core_virtual_network.vcn.default_security_list_id,
    oci_core_security_list.public_sl.id
  ]
  dhcp_options_id = oci_core_virtual_network.vcn.default_dhcp_options_id
  dns_label       = "fortipub"
  freeform_tags   = var.tag
}

# Accept Marketplace Image Terms
resource "oci_core_app_catalog_listing_resource_version_agreement" "image_agreement" {
  listing_id               = local.mp_listing_id
  listing_resource_version = local.mp_listing_resource_version
}

resource "oci_core_app_catalog_subscription" "image_subscription" {
  compartment_id           = var.compartment_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.image_agreement.eula_link
  listing_id               = local.mp_listing_id
  listing_resource_version = local.mp_listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.image_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.image_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.image_agreement.time_retrieved

  timeouts {
    create = "30m"
  }
}

# Create VM Instance
resource "oci_core_instance" "vm_instance" {
  depends_on = [oci_core_internet_gateway.igw]

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.product_name}-vm"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_cpu
    memory_in_gbs = var.instance_memory
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
    display_name     = "${var.product_name}-vnic"
    hostname_label   = "${var.product_name}-hostname"
  }

  launch_options {
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_type = "image"
    source_id = (
      var.product_name == "fortigate"
      ? var.source_id
      : (
        contains(["fortiguest", "fortiaiops", "fortimanager", "fortianalyzer"], var.product_name)
        ? lookup(
          jsondecode(file("${path.module}/source_id_maps/${var.product_name}_source_id_map.json"))[var.image_version],
          "source_id",
          null
        )
        : null
      )
    )

    boot_volume_size_in_gbs = 100
  }

  metadata = {
    user_data = base64encode(templatefile("${path.module}/${var.bootstrap_config}", {
      license_fortiflex     = var.license_fortiflex != null ? var.license_fortiflex : "",
      license_path          = var.license_path != null ? var.license_path : "",
      custom_data_file_path = var.custom_data_file_path != null ? var.custom_data_file_path : ""
    }))
  }

  timeouts {
    create = "60m"
  }

  freeform_tags = var.tag
}

# Attach Additional Volume
resource "oci_core_volume" "data_disk" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.product_name}-data-disk"
  size_in_gbs         = var.volume_size
  freeform_tags       = var.tag
}

resource "oci_core_volume_attachment" "data_disk_attachment" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.vm_instance.id
  volume_id       = oci_core_volume.data_disk.id
}
