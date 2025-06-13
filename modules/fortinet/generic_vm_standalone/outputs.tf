output "instance_public_ip" {
  value = oci_core_instance.vm_instance.public_ip
}

# output "instance_username" {
#   value = "admin"
# }
