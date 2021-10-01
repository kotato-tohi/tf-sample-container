output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sbn" {
  value = aws_subnet.pub_sbn
}

output "pvt_sbn" {
  value = aws_subnet.pvt_sbn
}
