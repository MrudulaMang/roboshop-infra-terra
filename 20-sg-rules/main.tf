

resource "aws_security_group_rule" "bastian_internet" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks      = "0.0.0.0/0"
  cidr_blocks       = local.my_ip # instead of internet we gave my lappy id
  security_group_id = local.bastian_sg_id
}

resource "aws_security_group_rule" "mongodb_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"

  #Catalogue:random_port → MongoDB:27017
  from_port         = 27017
  #MongoDB:27017 → Catalogue:49152(random port)
  to_port           = 27017
  
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.catalogue_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "redis_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.cart_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "mysql_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.mysql_sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.rabbitmq_sg_id
}