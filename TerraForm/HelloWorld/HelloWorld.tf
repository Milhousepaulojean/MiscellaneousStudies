resource local_file "HelloWorld-file" {
  sensitive_content = "Hello World"
  filename             = "${path.module}/files/outputfile"
  file_permission      = 0777
  directory_permission = 0777
}
