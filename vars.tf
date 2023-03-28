variable "env" {

}
variable "engine" {

}
variable "backup_retention_period" {

}
variable "preferred_backup_window" {

}

variable "subnet_ids" {

}

variable "tags" {

}

variable "engine_version" {

}

variable "storage_encrypted" {
  default = true

}

variable "skip_final_snapshot" {
  default = true
  
}

variable "instance_count" {

}

variable "instance_class" {

}

variable "dbname" {
  default = "dummy"
}

variable "allow_db_to_subnets" {
  
}
variable "vpc_id" {
  
}