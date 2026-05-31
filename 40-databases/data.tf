datasource "aws_ami" "joindevops" {
 most_recent = true
 owners = ["973714476881"]

 filter {
    name = "root_device_type"
    values = ["ebs"]
 }   

 filter {
    name = "name"
    values = ["Redhat-9-DevOps-practice"]
 }

 filter {
    name = "virtualization-type"
    values = "hvm"

 }
 /*owners
 name
 root_device_type
 virtualization_type*/

}

# vpc_id ; database_subnet_id ; MongoDB and redis mysql sg_ids

data "aws_ssm_parameter" "vpc_id" {
    value = "${var.project}/${var.project}"
}

data "aws_ssm_parameter" "database_subnet_id" {
    value = "${var.project}/${var.project}/databse-subnet-ids"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
    values = "${var.project}/${var.environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
    values = "${var.project}/${var.environment}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
    values = "${var.project}/${var.environment}/redis_sg_id"
}
data "aws_ssm_parameter" "rabbitmq_sg_id" {
    values = "${var.project}/${var.environment}/rabbitmq_sg_id"
}