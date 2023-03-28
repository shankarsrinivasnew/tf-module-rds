resource "aws_rds_cluster" "rdsr" {
  cluster_identifier      = "${var.env}-rds"
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.rds-user.value
  master_password         = data.aws_ssm_parameter.rds-pass.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  database_name           = var.dbname
  db_subnet_group_name    = aws_db_subnet_group.subgrpr.name
  kms_key_id              = data.aws_kms_key.mykey.arn
  storage_encrypted       = var.storage_encrypted
  skip_final_snapshot     = var.skip_final_snapshot
  vpc_security_group_ids  = [aws_security_group.sgr.id]


  tags = merge(
    var.tags,
    { Name = "${var.env}-rds" }
  )

}

resource "aws_db_subnet_group" "subgrpr" {
  name       = "${var.env}-rds-subnetgroup"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.env}-rds-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.rdsr.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.rdsr.engine
  engine_version     = aws_rds_cluster.rdsr.engine_version
}

resource "aws_ssm_parameter" "rds_endpoint_shipping" {
  name  = "${var.env}.rds_endpoint_shipping"
  type  = "String"
  value = aws_rds_cluster.rdsr.endpoint
}

resource "aws_security_group" "sgr" {
  name        = "rds-${var.env}-sg"
  description = "rds-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "rds port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allow_db_to_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { Name = "rds-${var.env}" }
  )
}
