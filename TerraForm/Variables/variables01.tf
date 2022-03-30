resource local_file name {
  sensitive_content = var.v1_teste
  filename             = "${path.module}/files/outputfile"
  file_permission      = 0777
  directory_permission = 0777
}

//Input via cmd
variable v1_teste {}

