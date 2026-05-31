resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true #incase existing records it overwrites                                                                                                                                                                                                                                                                  
 }

 resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environement}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true #incase existing records it overwrites                                                                                                                                                                                                                                                                  
 }

  resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environement}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true #incase existing records it overwrites                                                                                                                                                                                                                                                                  
 }

#session 41 timestamp1:05
   resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environement}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true #incase existing records it overwrites                                                                                                                                                                                                                                                                  
 }