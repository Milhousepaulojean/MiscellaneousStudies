provider "aws" {
  region = "us-east-1" # Defina a região AWS desejada
}

resource "aws_docdb_cluster_instance" "example_instance" {
  identifier                   = "example-instance01"
  instance_class               = "db.t3.medium" # Tipo de instância para o cluster
  cluster_identifier           = aws_docdb_cluster.example_cluster.id
  preferred_maintenance_window = "sun:06:00-sun:07:00"
}

resource "aws_docdb_cluster" "example_cluster" {
  cluster_identifier              = "example-cluster01"
  availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"] # Zonas de disponibilidade onde o cluster será criado
  db_subnet_group_name            = aws_db_subnet_group.example_db_subnet_group.name
  master_username                 = "foo"
  master_password                 = "barbut8chars" # Defina sua própria senha aqui
  skip_final_snapshot             = true
  apply_immediately               = true
  storage_encrypted               = true
  engine_version                  = "4.0.0"
  backup_retention_period         = 7
  preferred_backup_window         = "07:00-09:00"
  db_cluster_parameter_group_name = "default.docdb4.0"
  vpc_security_group_ids          = [aws_security_group.example_sg.id]
}

resource "aws_db_subnet_group" "example_db_subnet_group" {
  name       = "example-db-subnet-group"
  subnet_ids = ["subnet-0e4776f9b36289948", "subnet-06824c1051e07097b", "subnet-07c438607576854ec"] # IDs das sub-redes onde o cluster será criado
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg_01"
  description = "Allow inbound from any source"

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
}
