## 1.1.1 (Unreleased)

## 1.1.0 (September 24, 2026)

### Added

* Added FortiProxy support to `modules/fortinet/generic_vm_standalone`.
* Added support for deploying FortiProxy from an imported OCI custom image.
* Added post-deployment login outputs: `instance_id`, `admin_url`, `admin_username`, `admin_initial_password`, and `admin_login_note`.
* Added product-specific first-login guidance for FortiGate, FortiProxy, FortiManager, FortiAnalyzer, FortiGuest, and FortiAIOps.
* Added FortiProxy deployment documentation for the OCI custom image import workflow.
* Added FortiProxy examples to `terraform.tfvars.template`.
* Added newer Marketplace source map entries for FortiGuest, FortiAIOps, FortiManager, and FortiAnalyzer.

### Changed

* Refactored image selection logic to distinguish Marketplace-mapped products from products that require an explicit image OCID.
* Updated `product_name`, `image_version`, and `source_id` validation and documentation.
* Updated README content to describe OCI deployment behavior.
* Updated FortiGate, FortiGuest, FortiAIOps, FortiManager, and FortiAnalyzer examples to use newer image versions.

### Fixed

* Fixed FortiGuest source map key naming for Marketplace listing IDs.
* Fixed `image_version` validation messaging for FortiAIOps.
* Fixed missing first-login information in module outputs and documentation.

### Validated

* Verified Terraform formatting and validation for the generic VM standalone module.
* Verified single-VM deployments for FortiProxy, FortiGate, FortiGuest, and FortiManager on OCI.

## 1.0.0 (June 13, 2025)

* Initial release
