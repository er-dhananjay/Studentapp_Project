variable "studentapp_instance_type" {
    default = "t3.micro"
}
variable "studentapp_ami" {
    default = "ami-02b8269d5e85954ef"
}
variable "studentapp_key_name" {
    default = "dk"
}
variable "studentapp_instance_vpc_security_group_ids" {
    default = "sg-0f2758b7b37e072cf"
}
variable "studentapp_disable_api_termination" {
    default = false
}