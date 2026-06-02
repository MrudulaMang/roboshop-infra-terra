
#session 40
    # EC2 instance creation FOR db's
    # create ssh connection
    # copy bootstrap.sh to tmp
    # execute bootstrap to install anisble and corressponding db

resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_id
    vpc_security_group_ids = [local.mongodb_sg_id]

    tags = merge(
            local.common_tags,
            {
                Name ="${var.project}-${var.environment}-mongodb" 
            }
            )
}

    # timestamp 14.40
resource terraform_data "bootstrap_mongodb"{
     triggers_replace = [
        aws_instance.mongodb.id]
        #triggers when mongodb_id changes meaning when new instance is created
    }
    
    #instead of hardocding the login details see how u can use secrets
connection {
        type = "ssh" 
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip
    }

    # timestamp from sessiom TFS =22:26\
    # copying script file from here to mongo instance

provisioner "file"{
        source = "bootstrap.sh"        # copy file from here
        destination = "/tmp/bootstrap.sh" # to mongodb instance
    }

    #installing anisble and mongodb database in mongo instance by playbook which is in the script bootstrap.sh
    
provisioner "remote_exec" { 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh" ,
            "sudo sh /tmp/bootstrap.sh mongodb var.environment"
        ]
    }

/*
    Remote-exec:
    Terraform → SSH → 100 machines
    👉 Issues:
    - slow apply
    - partial failures
    - retries needed
    - fragile

|Aspect|        remote-exec|   user_data|
|---|           ---|           ---|
|Live logs|      ✅ Yes|    ❌ (unless centralized)can do by cloudwatch|
|SSH dependency|❌ Required|✅ Not needed|
|Scaling|       ❌ Poor|    ✅ Excellent|
|Reliability|   ❌ Fragile| ✅ Better|
|Cloud-native|  ❌ No|      ✅ Yes|

*/

#connect to mongodb and test the connection
#-----------REDIS SESSION 40


resource "aws_instance" "redis" {
    name = "${var.project}-${var.environment}-redis"
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_id
    vpc_security_group_ids = [local.redis_sg_id]
    tags = merge(
        {
            Name ="${var.project}-${var.environment}-redis" 
        },
        local.common_tags
    )
}

resource terraform_data "bootstrap_redis"{
     triggers_replace = [
        aws_instance.redis.id]
     #triggers when redis_id changes meaning when new instance is created
    }

    connection {
        type = "ssh" 
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }

    # timestamp from sessiom TFS =22:26
    provisioner "file"{
        source = "bootstrap.sh"        # copy file from here
        destination = "/tmp/bootstrap.sh" # to redis instance
    }


    provisioner "remote_exec" { 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh" ,
            "sudo sh /tmp/bootstrap.sh redis var.environment"
        ]
    }
#-----------------MYSQL SESSION 41


resource "aws_instance" "mysql" {
    name = "${var.project}-${var.environment}-mysql"
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_id
    vpc_security_ids = [local.redis_sg_id]
    iam_instance_profile = aws_iam_instance_profile.mysql.name

  
    tags = merge(
        {
            Name ="${var.project}-${var.environment}-mysql" 
        },
        local.common_tags
    )
}

resource terraform_data "bootstrap_mysql"{
     triggers_replace = [
        aws_instance.mysql.id]
     #triggers when mysql_id changes meaning when new instance is created
    }

    connection {
        type = "ssh" 
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mysql.private_ip
    }

    # timestamp from sessiom TFS =22:26
    provisioner "file"{
        source = "bootstrap.sh"           # copy file from here
        destination = "/tmp/bootstrap.sh" # to redis instance
    }


    provisioner "remote_exec" { 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh" ,
            "sudo sh /tmp/bootstrap.sh mysql var.environment"
        ]
    }

#---------------------RABBITMQ

resource "aws_instance" "rabbitmq" {
    name = "${var.project}-${var.environment}-rabbitmq"
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_id
    vpc_security_group_ids = [local.rabbitmq_sg_id]
  
    tags = merge(
        {
            Name ="${var.project}-${var.environment}-rabbitmq" 
        },
        local.common_tags
    )
}

resource terraform_data "bootstrap_rabbitmq"{
     triggers_replace = [
        aws_instance.rabbitmq.id]
          #filemd5("${path.module}/bootstrap.sh")
          #triggers when rabbitmq_id changes meaning when new instance is created
    }

    connection {
        type = "ssh" 
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.rabbitmq.private_ip
    }

    # timestamp from sessiom TFS =22:26
    provisioner "file"{
        source = "bootstrap.sh"        # copy file from here
        destination = "/tmp/bootstrap.sh" # to rabbitmq instance
    }


    provisioner "remote_exec" { 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh" ,
            "sudo sh /tmp/bootstrap.sh rabbitmq var.environment"
        ]
    }


#-------------------
   # Include a hash of the script in triggers_replace(even there is no change in instnace id and there is change is only in the script). if script fails and we need to reapply terra, then
   #   remote exec wont get executed as there is no change in the instance id. 
   # resource "terraform_data" "db_config" {
  # triggers_replace = [
  #  aws_instance.db.id,
  #  filemd5("${path.module}/bootstrap.sh")
  # ]

  /* TERRAFORM DATA
  Older Terraform examples often did:
    resource "aws_instance" "mongodb" {
    ...
    provisioner "file" {}
    provisioner "remote-exec" {}
    }

 But if the provisioning fails, the instance resource can end up in a messy state.
    Using:
    terraform_data
    separates:
    Infrastructure Creation
            from
    Configuration Step
    which is cleaner.
  */