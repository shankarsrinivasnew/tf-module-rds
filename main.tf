resource "aws_rds_cluster" "rdsr" {
  cluster_identifier      = "${var.env}-rds"
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.rds-user.value
  master_password         = data.aws_ssm_parameter.rds-pass.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  database_name           = var.dbname
  db_subnet_group_name    = aws_rds_subnet_group.subgrpr.name
  kms_key_id              = data.aws_kms_key.mykey.arn
  storage_encrypted       = var.storage_encrypted

  tags = merge(
    var.tags,
    { Name = "${var.env}-rds" }
  )

}

resource "aws_rds_subnet_group" "subgrpr" {
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