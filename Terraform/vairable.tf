variable "studentapp_instance_type" {
    default = "t3.micro"
}
variable "studentapp_ami" {
    default = "ami-0f00d706c4a80fd93"
}
variable "studentapp_key_name" {
    default = "mykey"
}
variable "studentapp_instance_vpc_security_group_ids" {
    default = "sg-0b4ace81d68dd0b6d"
}
variable "studentapp_disable_api_termination" {
    default = false
}