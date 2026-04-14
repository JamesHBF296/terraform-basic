output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "alb_arn" {
  value = aws_lb.web_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

output "listener_arn" {
  value = aws_lb_listener.web_listener.arn
}

output "alb_zone_id" {
  value = aws_lb.web_alb.zone_id
}