output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rtb.id
}