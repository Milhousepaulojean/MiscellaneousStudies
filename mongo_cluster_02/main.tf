provider "aws" {
  region = var.aws_region # Substitua pela região desejada
}
resource "aws_docdb_cluster" "default" {
  cluster_identifier = "docdb-cluster-demo"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  master_username    = var.aws_secret_user
  master_password    = var.aws_secret_pass
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.r5.large"
}
