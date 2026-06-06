# session 43
 # what does ami has , y adding instacne type in and other attributes in launch template.
 # WHAT IS update_default_version
  # what about target group size/ autoscaling how to control  or handle the volumes or disk size
 # when we delete the instance after ami creation then when we apply terra, ami willagain be created?
  # or if we change the version of eg. catalogue in anisible, how will terraform know to create  a new 
 # IF catalogue instance is in 1a and user incstances or busy if neede will it communicate the usser instance in 1b

resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh"    # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh catalogue ${var.environment} ${var.app_version}"
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
  # roboshop-dev-catalogue-v3-i-h468sghy
  name               = "${var.project}-${var.environment}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]
    #aws_ec2_instance_state is managed by the AWS provider and waits until the instance actually reaches the target state (stopped
    # A resource is not considered complete until all its provisioners finish successfully.
  tags = merge(
    {
        Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
    # time to wait before destroying the  instance  

    #1:12
  health_check {
    healthy_threshold = 2 # no of requets t pass
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2 # should get response in 2 secs
    unhealthy_threshold = 3
  }
}

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id

  # once autoscaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]

  # each time we apply terraform this version will be updated as default
  update_default_version = true
  
  # tags for instances created by launch template through autoscaling
  tag_specifications {
    resource_type = "instance"

    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
  }
  # tags for volumes created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
  }
  # tags for launch template
  tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project}-${var.environment}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }

  
  vpc_zone_identifier       = [local.private_subnet_id]
  target_group_arns = [aws_lb_target_group.catalogue.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  dynamic "tag" {
    for_each = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  # with in 15min autoscaling should be successful
  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${var.project}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

# This depends on target group
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  depends_on = [aws_autoscaling_policy.catalogue]
  
  # it executes in bastion
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id} "
  }
}

#--------------------------------------------------------
#One subtle issue: Terraform only knows that the stop command finished, not that the instance is actually in the stopped state.
  #For example:
  #aws ec2 stop-instances --instance-ids i-123
  #returns almost immediately while AWS may take 30–90 seconds to fully stop the instance.
  #In that case AMI creation might start too early.
  #Production-grade approach:
  #aws ec2 stop-instances --instance-ids i-123
  #aws ec2 wait instance-stopped --instance-ids i-123
  #or use a data/resource that explicitly waits for the instance state before creating the AMI.

  # For many applications AWS can create crash-consistent AMIs from a running instance. Stopping gives cleaner filesystem consistency but increases build time and causes downtime. The trade-off depends on whether this is a bake pipeline, a production server, or an ephemeral image-builder instance. That's the architectural question worth asking rather than just whether the dependencies work.