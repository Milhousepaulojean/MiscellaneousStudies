data "local_file" data_file{
    filename ="exemplo.txt"
}


output name {
  value = data.local_file.data_file.content
}

output name_base64{
    value = data.local_file.data_file.content_base64
}
