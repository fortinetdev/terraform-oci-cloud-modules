## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 3.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_app_catalog_listing_resource_version_agreement.image_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_listing_resource_version_agreement) | resource |
| [oci_core_app_catalog_subscription.image_subscription](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_subscription) | resource |
| [oci_core_instance.vm_instance](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.igw](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.public_rt](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.public_sl](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.public_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_virtual_network.vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_virtual_network) | resource |
| [oci_core_volume.data_disk](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_volume) | resource |
| [oci_core_volume_attachment.data_disk_attachment](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_volume_attachment) | resource |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | The availability domain where the instance will be created. Specify as a number (e.g., 1 for AD-1). | `number` | `1` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | The OCID of the compartment where resources will be created. | `any` | n/a | yes |
| <a name="input_custom_security_list_rules"></a> [custom\_security\_list\_rules](#input\_custom\_security\_list\_rules) | Map of security list rules to apply | <pre>object({<br/>    display_name = string<br/>    egress_security_rules = list(object({<br/>      destination = string<br/>      protocol    = string<br/>    }))<br/>    ingress_security_rules = list(object({<br/>      protocol  = string<br/>      source    = string<br/>      stateless = bool<br/>      tcp_options = optional(object({<br/>        min = number<br/>        max = number<br/>      }))<br/>      udp_options = optional(object({<br/>        min = number<br/>        max = number<br/>      }))<br/>      icmp_options = optional(object({<br/>        type = number<br/>        code = number<br/>      }))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | The fingerprint of the public key in Oracle Cloud Infrastructure. | `any` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of the image to be used. Required only if product\_name is one of 'fortimanager', 'fortianalyzer', 'fortiguest', or 'fortiaiops'. | `string` | `null` | no |
| <a name="input_instance_cpu"></a> [instance\_cpu](#input\_instance\_cpu) | The number of OCPUs to allocate for the instance. | `number` | `4` | no |
| <a name="input_instance_memory"></a> [instance\_memory](#input\_instance\_memory) | The amount of memory (in GB) to allocate for the instance. | `number` | `16` | no |
| <a name="input_instance_shape"></a> [instance\_shape](#input\_instance\_shape) | The shape of the instance to be created. Defines the number of OCPUs, memory, and other resources. | `string` | `"VM.Standard.E4.Flex"` | no |
| <a name="input_listing_resource_version"></a> [listing\_resource\_version](#input\_listing\_resource\_version) | The version of the Marketplace listing resource to use. Required only if product\_name is 'fortigate'. | `string` | `null` | no |
| <a name="input_mp_listing_id"></a> [mp\_listing\_id](#input\_mp\_listing\_id) | The OCID of the Marketplace listing to use for the instance. Required only if product\_name is 'fortigate'. | `string` | `null` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | The file path to the private key used for authentication. | `any` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | The name of the product to be created. Supported values are 'fortigate', 'fortiproxy', 'fortimanager', 'fortianalyzer', 'fortiguest', and 'fortiaiops'. | `string` | n/a | yes |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | The CIDR block for the public subnet within the VCN. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be created. | `any` | n/a | yes |
| <a name="input_source_id"></a> [source\_id](#input\_source\_id) | The OCID of the source image to use for the instance. Required if product\_name is 'fortigate' or 'fortiproxy'. For FortiProxy, use the OCID of the custom image imported from the Fortinet-provided image file. | `string` | `null` | no |
| <a name="input_tag"></a> [tag](#input\_tag) | Map of tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of your tenancy in Oracle Cloud Infrastructure. | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | The OCID of the user in Oracle Cloud Infrastructure. | `any` | n/a | yes |
| <a name="input_vcn_cidr_blocks"></a> [vcn\_cidr\_blocks](#input\_vcn\_cidr\_blocks) | A list of CIDR blocks for the Virtual Cloud Network (VCN). | `list(string)` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the block volume (in GB) to attach to the instance. | `number` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_initial_password"></a> [admin\_initial\_password](#output\_admin\_initial\_password) | Product-specific initial GUI password or first-login password guidance. |
| <a name="output_admin_login_note"></a> [admin\_login\_note](#output\_admin\_login\_note) | Additional product-specific login notes. |
| <a name="output_admin_url"></a> [admin\_url](#output\_admin\_url) | URL to access the product GUI. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | Initial GUI username. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | OCID of the deployed OCI instance. Some Fortinet products use this as the initial admin password. |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | Public IP assigned to the instance. |

## Post-deployment Login

Use the `admin_url`, `admin_username`, `admin_initial_password`, and `admin_login_note` outputs after `terraform apply`.

Initial GUI login defaults:

| Product | Username | Initial password |
| --- | --- | --- |
| FortiGate | `admin` | OCI instance OCID |
| FortiProxy | `admin` | OCI instance OCID |
| FortiManager | `admin` | OCI instance OCID |
| FortiAnalyzer | `admin` | OCI instance OCID |
| FortiGuest | `admin` | No password on first GUI login |
| FortiAIOps 2.x | `admin` | `admin` |
| FortiAIOps 3.x | `admin` | No password on first GUI login |

For FortiGuest, open `https://<public_ip>/adminportal/auth/login`. FortiGuest will prompt you to set a new password. GUI and CLI admin credentials are different.

## FortiProxy

FortiProxy on OCI is deployed from an imported custom image instead of a module-provided Marketplace source map. Download the FortiProxy OCI/KVM image from Fortinet Support, extract `fortiproxy.qcow2`, upload it to Object Storage, import it as a QCOW2 custom image, and use the imported image OCID as `source_id`.

```hcl
product_name    = "fortiproxy"
source_id       = "ocid1.image.oc1.<region>.<your_imported_fortiproxy_image_ocid>"
instance_cpu    = 2
instance_memory = 16
instance_shape  = "VM.Standard.E3.Flex"
```
