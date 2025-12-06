resource "aws_instance" "studentapp" {
    ami = var.studentapp_ami
    instance_type = var.studentapp_instance_type
    key_name = var.studentapp_key_name
    vpc_security_group_ids = [ var.studentapp_instance_vpc_security_group_ids ]
    disable_api_termination = var.studentapp_disable_api_termination
}