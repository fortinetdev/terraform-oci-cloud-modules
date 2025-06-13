Content-Type: multipart/mixed; boundary="==OCI=="
MIME-Version: 1.0

--==OCI==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
    set hostname "oci-test"
end

%{ if custom_data_file_path != "" }
${ file(custom_data_file_path) }
%{ endif }

%{ if license_fortiflex != "" }
execute vm-license ${license_fortiflex}
execute reboot
%{ endif }

%{ if license_path != "" }
--==OCI==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(license_path)}

%{ endif }

--==OCI==--
