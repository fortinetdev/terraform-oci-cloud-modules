// OCI Configuration
variable "tenancy_ocid" {
  description = "The OCID of your tenancy in Oracle Cloud Infrastructure."
}

variable "user_ocid" {
  description = "The OCID of the user in Oracle Cloud Infrastructure."
}

variable "private_key_path" {
  description = "The file path to the private key used for authentication."
}

variable "fingerprint" {
  description = "The fingerprint of the public key in Oracle Cloud Infrastructure."
}

variable "region" {
  description = "The region where the resources will be created."
}

variable "compartment_ocid" {
  description = "The OCID of the compartment where resources will be created."
}

// Network Configuration
variable "vcn_cidr_blocks" {
  description = "A list of CIDR blocks for the Virtual Cloud Network (VCN)."
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet within the VCN."
  type        = string
}

// Marketplace Image Configuration
variable "product_name" {
  description = "The name of the product to be created. Supported values are 'fortigate', 'fortiproxy', 'fortimanager', 'fortianalyzer', 'fortiguest', and 'fortiaiops'."
  type        = string

  validation {
    condition     = contains(["fortigate", "fortiproxy", "fortimanager", "fortianalyzer", "fortiguest", "fortiaiops"], var.product_name)
    error_message = "product_name must be one of 'fortigate', 'fortiproxy', 'fortimanager', 'fortianalyzer', 'fortiguest', or 'fortiaiops'."
  }
}

variable "image_version" {
  description = "The version of the image to be used. Required only if product_name is one of 'fortimanager', 'fortianalyzer', 'fortiguest', or 'fortiaiops'."
  type        = string
  default     = null

  validation {
    condition     = !contains(["fortimanager", "fortianalyzer", "fortiguest", "fortiaiops"], var.product_name) || (var.image_version != null && var.image_version != "")
    error_message = "image_version must be set when product_name is one of 'fortimanager', 'fortianalyzer', 'fortiguest', or 'fortiaiops'."
  }
}

// Instance Configuration
variable "instance_shape" {
  description = "The shape of the instance to be created. Defines the number of OCPUs, memory, and other resources."
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "instance_cpu" {
  description = "The number of OCPUs to allocate for the instance."
  type        = number
  default     = 4
}

variable "instance_memory" {
  description = "The amount of memory (in GB) to allocate for the instance."
  type        = number
  default     = 16
}

variable "availability_domain" {
  description = "The availability domain where the instance will be created. Specify as a number (e.g., 1 for AD-1)."
  type        = number
  default     = 1
}

variable "volume_size" {
  description = "The size of the block volume (in GB) to attach to the instance."
  type        = number
  default     = 100
}

variable "custom_security_list_rules" {
  description = "Map of security list rules to apply"
  type = object({
    display_name = string
    egress_security_rules = list(object({
      destination = string
      protocol    = string
    }))
    ingress_security_rules = list(object({
      protocol  = string
      source    = string
      stateless = bool
      tcp_options = optional(object({
        min = number
        max = number
      }))
      udp_options = optional(object({
        min = number
        max = number
      }))
      icmp_options = optional(object({
        type = number
        code = number
      }))
    }))
  })
}

variable "mp_listing_id" {
  description = "The OCID of the Marketplace listing to use for the instance. Required only if product_name is 'fortigate'."
  type        = string
  default     = null

  validation {
    condition     = var.product_name != "fortigate" || (var.product_name == "fortigate" && can(regex("ocid1.appcataloglisting.oc1..*", var.mp_listing_id)))
    error_message = "mp_listing_id must be a valid OCID for a Marketplace listing when product_name is 'fortigate'."
  }
}

variable "listing_resource_version" {
  description = "The version of the Marketplace listing resource to use. Required only if product_name is 'fortigate'."
  type        = string
  default     = null

  validation {
    condition     = var.product_name != "fortigate" || (var.product_name == "fortigate" && can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+(_.*)?$", var.listing_resource_version)))
    error_message = "listing_resource_version must be a valid version string when product_name is 'fortigate'."
  }

}

variable "source_id" {
  description = "The OCID of the source image to use for the instance. Required if product_name is 'fortigate' or 'fortiproxy'. For FortiProxy, use the OCID of the custom image imported from the Fortinet-provided image file."
  type        = string
  default     = null

  validation {
    condition     = !contains(["fortigate", "fortiproxy"], var.product_name) || can(regex("ocid1.image.oc1..*", var.source_id))
    error_message = "source_id must be a valid OCI image OCID when product_name is 'fortigate' or 'fortiproxy'."
  }

}

variable "bootstrap_config" {
  description = "The bootstrap configuration for the instance. Optional and used for FortiGate and FortiProxy bootstrap data."
  type        = string
  default     = "./bootstrap_config.tpl"

  validation {
    condition     = !contains(["fortigate", "fortiproxy"], var.product_name) || var.bootstrap_config == null || var.bootstrap_config != ""
    error_message = "If provided, bootstrap_config must not be an empty string when product_name is 'fortigate' or 'fortiproxy'."
  }

}

variable "license_path" {
  description = "The path to the license file to be used for the instance. Optional and used for FortiGate and FortiProxy."
  type        = string
  default     = null

  validation {
    condition     = !contains(["fortigate", "fortiproxy"], var.product_name) || var.license_path == null || var.license_path != ""
    error_message = "If provided, license_path must not be an empty string when product_name is 'fortigate' or 'fortiproxy'."
  }
}

variable "license_fortiflex" {
  description = "The FlexToken for the license. Optional and used for FortiGate and FortiProxy."
  type        = string
  default     = null

  validation {
    condition     = !contains(["fortigate", "fortiproxy"], var.product_name) || var.license_fortiflex == null || var.license_fortiflex != ""
    error_message = "If provided, license_fortiflex must not be an empty string when product_name is 'fortigate' or 'fortiproxy'."
  }
}

variable "custom_data_file_path" {
  description = "The path to the custom data file to be used for the instance. Optional and used for FortiGate and FortiProxy."
  type        = string
  default     = null

  validation {
    condition     = !contains(["fortigate", "fortiproxy"], var.product_name) || var.custom_data_file_path == null || var.custom_data_file_path != ""
    error_message = "If provided, custom_data_file_path must not be an empty string when product_name is 'fortigate' or 'fortiproxy'."
  }
}

variable "tag" {
  description = "Map of tags to apply to the resources"
  type        = map(string)
  default     = {}
}
