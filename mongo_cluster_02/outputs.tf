output "mongo_instance_ips" {
  value = aws_instance.mongo_instance[*].public_ip
}
