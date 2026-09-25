Deploy a single Fortinet product on OCI, including FortiGate, FortiProxy, FortiManager, FortiAnalyzer, FortiGuest, or FortiAIOps, using the streamlined Terraform module generic_vm_standalone.

**Introduction**

This Terraform module, located at `/modules/fortinet/generic_vm_standalone`, provides a streamlined solution for deploying a single Fortinet Virtual Machine on Oracle Cloud Infrastructure. It supports a range of Fortinet products, including FortiGate, FortiProxy, FortiManager, FortiAnalyzer, FortiGuest, and FortiAIOps. FortiProxy uses the OCID of a custom image imported from the Fortinet-provided image file.

**Deployment Steps**

1. Rename the `terraform.tfvars.template` file to `terraform.tfvars`.
2. In the `terraform.tfvars` file, you will find blocks corresponding to different Fortinet product images. Select the block that matches the product you wish to deploy.
3. Update all placeholder values labeled as `"YOUR_OWN_VALUE"` with values specific to your deployment requirements.
4. Initialize and apply the Terraform configuration by running the following commands:

  ```sh
  terraform init
  terraform apply
  ```

**FortiProxy on OCI**

FortiProxy is supported on OCI, but it is different from the Marketplace-mapped products in this module. FortiProxy does not use a module-provided Marketplace `source_id` map. To deploy a single FortiProxy VM, first import the FortiProxy image into OCI as a custom image, then set `product_name = "fortiproxy"` and set `source_id` to that imported custom image OCID.

Typical flow:

1. Download the FortiProxy OCI/KVM image package from Fortinet Support.
2. Extract the package and locate `fortiproxy.qcow2`.
3. Upload `fortiproxy.qcow2` to an OCI Object Storage bucket in your target compartment.
4. Import that object as an OCI custom image with image type `QCOW2`.
5. Wait until the custom image state is `AVAILABLE`.
6. Use the custom image OCID as `source_id` in `terraform.tfvars`.

Example:

```hcl
product_name    = "fortiproxy"
source_id       = "ocid1.image.oc1.<region>.<your_imported_fortiproxy_image_ocid>"
instance_cpu    = 2
instance_memory = 16
instance_shape  = "VM.Standard.E3.Flex"
```

**Post-Deployment: Instance Information**

Once the deployment is complete, Terraform will display the following information:

Public IP Address: The public IP assigned to the instance.

Admin URL: The URL to open the product GUI.

Admin Username: The initial GUI username.

Admin Initial Password: Product-specific first-login guidance.

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

For FortiGuest, use the `admin_url` output, which includes `/adminportal/auth/login`. FortiGuest GUI and CLI admin credentials are different.
