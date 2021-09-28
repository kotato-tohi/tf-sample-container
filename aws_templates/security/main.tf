#-------------------------------------------#
# ALB Security Group
#-------------------------------------------#

resource "aws_security_group" "sg_alb" {

  name        = "sg_alb"
  description = "Allow inbound traffic alb"
  vpc_id      = var.vpc_id

  egress = [
    {
      description      = "outbound allow rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}


### -------------------------------------------#
### ALB dev environmetn rules
### -------------------------------------------#

resource "aws_security_group_rule" "alb_http_main" {
	count = "${var.env_tag == "dev" ? 1 : 0}"
  description       = "Allow http traffic from internet b/g_deploment main fraffic"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "alb_https_main" {
  count = "${var.env_tag == "dev" ? 1 : 0}"
  description       = "Allow https traffic from internet b/g_deployment main traffic"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "alb_http_test" {
  count = "${var.env_tag == "dev" ? 1 : 0}"
  description       = "Allow http traffic from internet b/g_deploment test fraffic"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${var.myip}"]
  security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "alb_https_test" {
  count = "${var.env_tag == "dev" ? 1 : 0}"
  description       = "Allow https traffic from internet b/g_deployment test traffic"
  type              = "ingress"
  from_port         = 4430
  to_port           = 4430
  protocol          = "tcp"
  cidr_blocks       = ["${var.myip}"]
  security_group_id = aws_security_group.sg_alb.id
}


### -------------------------------------------#
### ALB stg environmetn rules
### -------------------------------------------#

# sample 
# resource "aws_security_group_rule" "alb_http_main" {
# 	count = "${var.env_tag == "stf" ? 1 : 0}"   <===**** if var.env_tag = "stg" then create this resouece
#   description       = "Allow http traffic from internet b/g_deploment main fraffic"
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"] 
#   security_group_id = aws_security_group.sg_alb.id
# }


### -------------------------------------------#
### ALB prod environmetn rules
### -------------------------------------------#

# sample 
# resource "aws_security_group_rule" "alb_http_main" {
# 	count = "${var.env_tag == "prod" ? 1 : 0}"   <===**** if var.env_tag = "prod" then create this resouece
#   description       = "Allow http traffic from internet b/g_deploment main fraffic"
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg_alb.id
# }



#-------------------------------------------#
# ECS Security Group
#-------------------------------------------#
resource "aws_security_group" "sg_ecs" {

  name        = "sg_ecs"
  description = "Allow inbound traffic alb"
  vpc_id      = var.vpc_id

  egress = [
    {
      description      = "outbound allow rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}


### -------------------------------------------#
### ECS dev environmetn rules
### -------------------------------------------#

resource "aws_security_group_rule" "ecs_http" {
  count = "${var.env_tag == "dev" ? 1 : 0}"
  description       = "Allow http traffic from internet b/g_deploment main fraffic"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.sg_ecs.id
  security_group_id = aws_security_group.sg_ecs.id
}


### -------------------------------------------#
### ECS stg environmetn rules
### -------------------------------------------#

# sample
# resource "aws_security_group_rule" "ecs_https" {
#   count = "${var.env_tag == "stg" ? 1 : 0}"
#   description       = "Allow http traffic from internet b/g_deploment main fraffic"
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   source_security_group_id = aws_security_group.sg_alb.id
#   security_group_id = aws_security_group.sg_alb.id
# }

### -------------------------------------------#
### ECS prod environmetn rules
### -------------------------------------------#

# sample
# resource "aws_security_group_rule" "ecs_https" {
#   count = "${var.env_tag == "stg" ? 1 : 0}"
#   description       = "Allow http traffic from internet b/g_deploment main fraffic"
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   source_security_group_id = aws_security_group.sg_alb.id
#   security_group_id = aws_security_group.sg_alb.id
# }
