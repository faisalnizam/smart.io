output "private_subnets_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "public_subnets_id" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}


