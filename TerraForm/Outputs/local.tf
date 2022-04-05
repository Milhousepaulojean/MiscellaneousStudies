resource local_file saida_com_output_tela {
  sensitive_content = var.variavel_output
  filename             = "${path.module}/files/outputfile_saidas_com_output"
  file_permission      = 0777
  directory_permission = 0777
}

variable variavel_output {
  type        = string
  default     = "saida"
  description = "description"
}

output output_id_conteudo {
  value       = resource.local_file.saida_com_output_tela.id
}
