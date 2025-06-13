Deploy a single Fortinet product on Azure, including FortiGate, FortiManager, FortiAnalyzer, FortiGuest, or FortiAIOps, using the streamlined and efficient Terraform module generic_vm_standalone.

**Introduction**

This Terraform module, located at `/modules/fortinet/generic_vm_standalone`, provides a streamlined solution for deploying a single Fortinet Virtual Machine on Microsoft Azure. It supports a range of Fortinet products, including FortiGate, FortiManager, FortiAnalyzer, FortiGuest, and FortiAIOps. By following the steps outlined below, you can efficiently set up and configure your desired Fortinet product in the Azure environment.

**Deployment Steps**

1. Rename the `terraform.tfvars.template` file to `terraform.tfvars`.
2. In the `terraform.tfvars` file, you will find five blocks corresponding to different Fortinet product images. Select the block that matches the product you wish to deploy.
3. Update all placeholder values labeled as `"YOUR_OWN_VALUE"` with values specific to your deployment requirements.
4. Initialize and apply the Terraform configuration by running the following commands:

  ```sh
  terraform init
  terraform apply
  ```

**Post-Deployment: Instance Information**

Once the deployment is complete, Terraform will display the following information:

Public IP Address: The public IP assigned to the instance.
