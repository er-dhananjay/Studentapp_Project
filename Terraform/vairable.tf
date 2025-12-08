variable "vpc_id" {}

variable "studentapp_ami" {
  default = "ami-0e99e33f6fa70e4f4"
}
variable "studentapp_instance_type" {
  default = "t2.micro"
}
variable "studentapp_key_name" {
  default = "studentapp-key"
}

variable "studentapp_db_username" {
  default = "admin"
}
variable "studentapp_db_password" {
  default = "12345678"
}
variable "studentapp_db_allocated_storage" {
  default = 20
}
variable "studentapp_db_db_name" {
  default = "studentapp"
}
variable "studentapp_db_instance_class" {
  default = "db.t3.micro"
}
