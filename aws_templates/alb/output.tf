output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_tgs" {
    value = aws_lb_target_group.alb_tg
}