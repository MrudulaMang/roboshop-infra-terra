locals {        
    common_tags ={
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    ami_id = data.joindevops.ami_id.value
    vpc_id = data.aws_ssm_parameter.vpc_id.value

    #getting us-east-1a from the subnet_ids
    public_subnet_id =  split(",",data.aws_ssm_parameter.public_subnet_ids.value)[0]
    
    bastian_sg_id = data.aws_ssm_parameter.bastian_internet.value
}