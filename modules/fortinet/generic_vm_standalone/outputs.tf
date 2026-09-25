locals {
  image_version_for_login = var.image_version == null ? "" : var.image_version
  fortiaiops_2x           = var.product_name == "fortiaiops" && can(regex("^2\\.", local.image_version_for_login))
  fortiaiops_3x           = var.product_name == "fortiaiops" && can(regex("^3\\.", local.image_version_for_login))

  admin_initial_password = (
    var.product_name == "fortiguest"
    ? "No password is required for the first GUI login. You will be prompted to set a new password."
    : local.fortiaiops_2x
    ? "admin"
    : local.fortiaiops_3x
    ? "No password is required for the first GUI login. You will be prompted to set a new password."
    : contains(["fortigate", "fortiproxy", "fortimanager", "fortianalyzer"], var.product_name)
    ? oci_core_instance.vm_instance.id
    : "See admin_login_note."
  )

  admin_login_note = (
    var.product_name == "fortiguest"
    ? "FortiGuest GUI and CLI admin credentials are different. Use the admin_url output for the GUI."
    : local.fortiaiops_2x
    ? "FortiAIOps 2.x GUI default is admin/admin. CLI default is admin with no password, and CLI and GUI users are different."
    : local.fortiaiops_3x
    ? "FortiAIOps 3.x GUI default is admin with no password. CLI and GUI passwords are synchronized after the first password change."
    : contains(["fortigate", "fortiproxy", "fortimanager", "fortianalyzer"], var.product_name)
    ? "The initial admin password is the OCI instance OCID unless changed by bootstrap or product-specific setup."
    : "Check the Fortinet product documentation for first-login credentials."
  )
}

output "instance_id" {
  value       = oci_core_instance.vm_instance.id
  description = "OCID of the deployed OCI instance. Some Fortinet products use this as the initial admin password."
}

output "instance_public_ip" {
  value       = oci_core_instance.vm_instance.public_ip
  description = "Public IP assigned to the instance."
}

output "admin_url" {
  value = (
    var.product_name == "fortiguest"
    ? "https://${oci_core_instance.vm_instance.public_ip}/adminportal/auth/login"
    : "https://${oci_core_instance.vm_instance.public_ip}"
  )
  description = "URL to access the product GUI."
}

output "admin_username" {
  value       = "admin"
  description = "Initial GUI username."
}

output "admin_initial_password" {
  value       = local.admin_initial_password
  description = "Product-specific initial GUI password or first-login password guidance."
}

output "admin_login_note" {
  value       = local.admin_login_note
  description = "Additional product-specific login notes."
}
