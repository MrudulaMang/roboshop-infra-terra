# session 38 : we retrieving vpc_id from data source and
# creating security groups for each component(mongodb,catalogue,...) 
# storing sg_ids in aws_ssm_parameter

/*
module "sg" {
    count = length(var.sg_names)
    source = "../terraform_aws_sg"
    project = var.project
    environment = var.environment
    sg_name = replace(var.sg_names[count.index],"_","-")
    vpd_id = local.vpc_id
}

*/
 count is danger in production, if one sg name is deleted index shifts,
 Use for_each for infrastructure
 Avoid count for mutable resources
*/

module "sg" {
  for_each = toset(var.sg_names)

  source      = "../../terraform_aws_sg" # even though in loop gets module code only once and store in memory
  project     = var.project
  environment = var.environment
  sg_name     = replace(each.value, "_", "-") # want backend_alb like names as  as backend-alb
  vpc_id      = local.vpc_id
}