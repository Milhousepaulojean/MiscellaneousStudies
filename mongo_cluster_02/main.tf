# provider "aws" {
#   region = "us-west-2" # Substitua pela região desejada
# }
# resource "aws_docdb_cluster" "default" {
#   cluster_identifier = "docdb-cluster-demo"
#   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   master_username    = "foo"
#   master_password    = "barbut8chars"
# }



# resource "aws_docdb_cluster_instance" "cluster_instances" {
#   count              = 1
#   identifier         = "docdb-cluster-demo-${count.index}"
#   cluster_identifier = aws_docdb_cluster.default.id
#   instance_class     = "db.r5.large"
# }

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb_sg"
  description = "Security group for MongoDB instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite conexões SSH de qualquer lugar
  }
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mongodb_sg"
  }
}


resource "aws_key_pair" "my_key_pair" {
  key_name   = "meu-keypair"                      # Nome do par de chaves na AWS
  public_key = file("~/.ssh/chavesExample01.pub") # Caminho para a chave pública local
}


resource "aws_instance" "mongo_instance" {
  count         = var.num_instances
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "MongoDB_Instance_${count.index + 1}"
  }

  security_groups = [aws_security_group.mongodb_sg.name]


  #   user_data = <<-EOF
  #               #!/bin/bash
  #               sudo yum update -y
  #               sudo yum install -y docker
  #               sudo service docker start
  #               sudo docker run --name mongo -p 27017:27017 -d mongo
  #               EOF

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/chavesExample01.cer")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo yum install -y mongodb-org",
      "sudo systemctl start mongodb",
      "sudo systemctl enable mongodb",
      "mongo admin --host localhost --eval 'db.getSiblingDB('fiap')'",
      "mongo admin --host localhost --eval 'db.createCollection('categories')'"
    ]
  }
}



# resource "aws_instance" "mongodb" {
#   count           = 1
#   ami             = "ami-0f403e3180720dd7e"
#   instance_type   = "t2.micro"
#   key_name        = aws_key_pair.my_key_pair.key_name
#   security_groups = [aws_security_group.mongodb_sg.name]

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y docker
#               sudo service docker start
#               sudo docker run --name mongo -p 27017:27017 -d mongo
#               EOF

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"                           # O usuário SSH padrão para a AMI do Ubuntu
#     private_key = file("~/.ssh/chavesExample01.pem") # Substitua pelo caminho para a sua chave SSH privada
#     host        = self.public_ip                     # Use self.public_ip para se conectar à instância usando seu endereço IP público
#   }

#   #   provisioner "remote-exec" {
#   #     inline = [
#   #       "sleep 120",
#   #       "sudo apt-get update",
#   #       "sudo apt-get install -y mongodb",
#   #       "sudo systemctl start mongodb",
#   #       "sudo systemctl enable mongodb"
#   #       # Adicione aqui os comandos para configurar o MongoDB conforme necessário
#   #     ]
#   #   }

# }
# output "mongo_public_ip" {
#   value = aws_instance.mongodb.public_ip
# }
