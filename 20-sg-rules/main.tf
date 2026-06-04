

resource "aws_security_group_rule" "bastian_internet" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks      = "0.0.0.0/0"
  #cidr_blocks       = local.my_ip # instead of internet we gave my lappy id
  cidr_blocks = ["${var.my_ip}/32"]
  security_group_id = local.bastian_sg_id
}

resource "aws_security_group_rule" "mongodb_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = local.bastian_sg_id
    # from which server the traffic is allowed
  security_group_id = local.mongodb_sg_id
    #to which security group this rule should be attached to
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
resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.payment_sg_id
  security_group_id = local.rabbitmq_sg_id
}

# Catalogue
resource "aws_security_group_rule" "catalogue_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.catalogue_sg_id
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.catalogue_sg_id
}

# User
resource "aws_security_group_rule" "user_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.user_sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.user_sg_id
}

# Cart
resource "aws_security_group_rule" "cart_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.cart_sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.cart_sg_id
}

# Shipping
resource "aws_security_group_rule" "shipping_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.shipping_sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.shipping_sg_id
}

# Payment
resource "aws_security_group_rule" "payment_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.payment_sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.backend_alb_sg_id
  security_group_id = local.payment_sg_id
}

# Backend ALB
resource "aws_security_group_rule" "backend_alb_bastian" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_catalogue" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.catalogue_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_user" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.user_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.cart_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.shipping_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.payment_sg_id
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.frontend_sg_id
  security_group_id = local.backend_alb_sg_id
}

# Frontend
resource "aws_security_group_rule" "frontend_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastian_sg_id
  security_group_id = local.frontend_sg_id
}

resource "aws_security_group_rule" "frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.frontend_alb_sg_id
  security_group_id = local.frontend_sg_id
}

# Frontend ALB
resource "aws_security_group_rule" "frontend_alb_public" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.frontend_alb_sg_id
}

# Open VPN
resource "aws_security_group_rule" "openvpn_public_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

# Admin UI
resource "aws_security_group_rule" "openvpn_public_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  # Where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

resource "aws_security_group_rule" "backend_alb_openvpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.openvpn_sg_id
  security_group_id = local.backend_alb_sg_id
}