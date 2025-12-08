variable "studentapp_instance_type" {
    default = "t3.micro"
}
variable "studentapp_ami" {
    default = "ami-02b8269d5e85954ef"
}
variable "studentapp_key_name" {
    default = "studentapp-key"
}
variable "studentapp_instance_vpc_security_group_ids" {
    default = "sg-0f2758b7b37e072cf"
}
variable "studentapp_disable_api_termination" {
    default = false
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