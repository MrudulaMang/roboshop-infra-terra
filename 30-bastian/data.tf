
data "aws_ami" "joindevops"{
    most_recent = true
    owners = ["973714476881"] #AWS account ID of whoever published the AMI.

    filter {
        name = "name"
        values = ["Redhat-9-DevOps-practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}

data "aws_ssm_parameter" "vpc_id" {
    value = "${var.project}/${var.environment}"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    value = "${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "bastian_sg_id" {
    value = "${var.project}/${var.environment}/bastian_sg_id"
}
