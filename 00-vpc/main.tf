# we are creating vpc, subnets and peering
# storing vpc_id in ssm parameter store

module "vpc" {
    source = "git::https://github.com/MrudulaMang/terraform-aws-vpc"
    #source = "../../terraform-aws-vpc"
    project = var.project
    environment = var.environment
    vpc_cidr  = var.vpc_cidr
    is_peering_required = true 
}