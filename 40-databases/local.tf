locals {
    common_tags {
        Project = var.project
        Environment = var.environment
        Terraform = true
    },
    vpc_id = data.joindevops.vpc_id
    
    #public subnet 1a
    database_subnet_id = split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0]
    
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value 
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value 
     
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value 
    mysql_role_name = join("-",[
     for name in ["${var.project}","${var.environment}","mysql"] : title(name) ]
    )
    #aws does not use "-" in naming convention for policies
    mysql_role_name = join("",[
     for name in ["${var.project}","${var.environment}","mysql"] : title(name) ]
    )

    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value 
}