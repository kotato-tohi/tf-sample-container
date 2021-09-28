resource "aws_lb" "alb" {
  name               = "${var.tag_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb.id]
  subnets            = var.pub_sbn.*.id

  enable_deletion_protection = false

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }

}


resource "aws_lb_target_group" "alb_tg" {
  count = var.tg_cnt
  name     = "${var.tag_name}-tg${1+count.index}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_listener" "alb_listener" {
	count = var.tg_cnt
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listrn_port_list[count.index]
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg[count.index].arn
  }
}