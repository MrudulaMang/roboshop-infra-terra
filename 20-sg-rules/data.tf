data "http" "my_public_ip_v4" {
    url = "http://ip4.icanhazip.com"
}

output "my_ip_address" {
  value = chomp(data.http.my_public_ip_v4.response_body)
}

data "aws_ssm_parameter" "bastian_sg_id"{
    value = "/${var.project}/${var.environment}/$bastian_sg_id"
}

data "aws_ssm_parameter" "mongodb_sg_id"{
    value = "/${var.project}/${var.environment}/$mongodb_sg_id"
}

data "aws_ssm_parameter" "catalogue_sg_id"{
    value = "/${var.project}/${var.environment}/$catalogue_sg_id"
}
data "aws_ssm_parameter" "user_sg_id"{
    value = "/${var.project}/${var.environment}/$user_sg_id"
}
data "aws_ssm_parameter" "shipping_sg_id"{
    value = "/${var.project}/${var.environment}/$shipping_sg_id"
}
data "aws_ssm_parameter" "payment_sg_id"{
    value = "/${var.project}/${var.environment}/$payment_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id"{
    value = "/${var.project}/${var.environment}/$redis_sg_id"
}
data "aws_ssm_parameter" "mysql_sg_id"{
    value = "/${var.project}/${var.environment}/$mysql_sg_id"
}
data "aws_ssm_parameter" "rabbitmq_sg_id"{
    value = "/${var.project}/${var.environment}/$rabbitmq_sg_id"
}

