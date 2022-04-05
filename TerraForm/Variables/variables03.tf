resource local_file name3 {
  sensitive_content = var.teste_external
  filename             = "${path.module}/files/outputfile3"
  file_permission      = 0777
  directory_permission = 0777
}

resource local_file name4 {
  sensitive_content = var.conteudo
  filename             = "${path.module}/files/outputfile4"
  file_permission      = 0777
  directory_permission = 0777
}