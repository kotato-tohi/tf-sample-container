output "alb" {
  value = aws_lb.alb
}

output "alb_tgs" {
  value = aws_lb_target_group.alb_tg
}

output "alb_listeners" {
  value = aws_lb_listener.alb_listener
}
