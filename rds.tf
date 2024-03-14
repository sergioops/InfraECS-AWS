resource "aws_rds_cluster" "aurora_cluster" {
  count   = length(var.db_cluster)
  cluster_identifier              = "${var.customer_name}-${var.db_cluster[count.index]}"
  engine                          = "aurora-postgresql"
  engine_version                  = "16.1"
  db_cluster_parameter_group_name = "default.aurora-postgresql16"
  master_username                 = var.rds_username
  master_password                 = ""
  skip_final_snapshot             = true
  apply_immediately               = true
  deletion_protection             = false
  vpc_security_group_ids          = [aws_security_group.rede-interna.id]
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  tags = {
    env = "${terraform.workspace}"
    layer = "data"
    app = "${var.db_cluster[count.index]}"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }

}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count                                 = length(var.db_cluster)
  identifier                            = "${var.db_cluster[count.index]}"
  cluster_identifier                    = aws_rds_cluster.aurora_cluster[count.index].id
  instance_class                        = lookup(var.db_instance, var.db_cluster[count.index])
  engine                                = aws_rds_cluster.aurora_cluster[count.index].engine
  engine_version                        = aws_rds_cluster.aurora_cluster[count.index].engine_version
  publicly_accessible                   = false
  apply_immediately                     = true
  performance_insights_enabled          = true
  performance_insights_retention_period = "7"
  tags = {
    env = "${terraform.workspace}"
    layer = "data"
    app = "${var.db_cluster[count.index]}"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "subnet-group-${terraform.workspace}"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
  }
}

