# session 39
#creating bastian host 
# creating iam role for bastian instance to configure backend and database instances 

resource "aws_instance" "bastian" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_id = local.vpc_id
    subnet_id = local.public_subnet_id
    vpc_security_ids = [local.bastian_sg_id]
    iam_instance_profile = aws_iam_instance_profile.bastian.name
    user_data = file("bastian.sh") #script to create disk extension and fo terraform 

    root_block_device {
      volume_size = 50
      volume_type = "gp3"
      tags = merge(
        {
            Name ="${var.project}-${var.environment}-bastian" 
        },
        local.common_tags
    )
    }


    tags = merge (
        {
            Name ="${var.project}-${var.environment}-bastian" 
        },
        local.common_tags
    )
}

# aws_iam_role '; aws_instance_policy_attachment ; aws_instance_policy_attachment
resource "aws_iam_role" "bastian" {
  name = "RoboshopDevBastian"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "RoboshopDevBastian"
  }
}

resource "aws_instance_policy_attachment" "bastian" {
   
    role = aws_iam_role.bastian.name
    #policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    policy_arn = "arn:aws:iam::aws:policy/AdministartorAccess" 
      # temp giving admin access will create different roles later and attach to roboshopdev RoboshopDevBastian
}

    # ec2 is not an iam identity, role needs credentials and should be trusted entity. 
    # aws creates credentials for this role by creating instance policy
resource "aws_instance_policy_attachment" "bastian" {
     name = "${var.project}-${var.environment}-bastian" 
     role = aws_iam_role.bastian.name
}


# we gave admin access to bastian just for learning purpose. otherwise we need to rigid with iam policies
#  for security reasons
  # like only, s3 access for state file crete, read and update
             #r53 create read and update
             #ec2 creation access 

/*STS = Security Token Service.
  When an EC2 instance assumes a role, AWS STS generates temporary credentials:

  Access Key
  Secret Key
  Session Token

  and delivers them to the instance through IMDS (Instance Metadata Service).
*/