resource local_file name3 {
  content = var.conteudo_ts
  filename             = "${path.module}/files/outputfile3"
  file_permission      = 0777
  directory_permission = 0777
}
