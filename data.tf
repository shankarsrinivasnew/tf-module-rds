data "aws_ssm_parameter" "rds-user" {
  name = "${var.env}.rds_user"
}

data "aws_ssm_parameter" "rds-pass" {
  name = "${var.env}.rds_pass"
}

data "aws_kms_key" "mykey" {
  key_id = "alias/terraform-b71"
}
