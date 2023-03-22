data "aws_ssm_parameter" "rds-user" {
  name = "${var.env}.rds.user"
}

data "aws_ssm_parameter" "rds-pass" {
  name = "${var.env}.rds.pass"
}

data "aws_kms_key" "mykey" {
  key_id = "alias/terraform-b71"
}