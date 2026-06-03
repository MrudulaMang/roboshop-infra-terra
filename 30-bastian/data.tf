
data "aws_ami" "joindevops" {
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

# no need to mention vpc id as terraform automatifcally assumes vpc depending on the chosen subnet
data "aws_ssm_parameter" "public_subnet_ids" {
    name = "${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "bastian_sg_id" {
    name = "${var.project}/${var.environment}/bastian_sg_id"
}
