provider "aws" {
  region = "sua-regiao-aqui"
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb_sg"
  description = "Security group for MongoDB instances"

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

resource "aws_instance" "mongo_instance" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t2.micro"

  tags = {
    Name = "MongoDB_Instance"
  }

  security_groups = [aws_security_group.mongodb_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo docker run --name mongo -p 27017:27017 -d mongo
              EOF

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/chavesExample01.pub")
    host        = self.public_ip
  }
}

output "mongo_public_ip" {
  value = aws_instance.mongo_instance.public_ip
}
