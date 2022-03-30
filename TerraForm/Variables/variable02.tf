resource local_file name2 {
  sensitive_content = var.v2_teste
  filename             = "${path.module}/files/outputfile2"
  file_permission      = 0777
  directory_permission = 0777
}

variable v2_teste {
  type        = string
  default     = "Teste variaveis locais"
  description = "valor mockado"
}

