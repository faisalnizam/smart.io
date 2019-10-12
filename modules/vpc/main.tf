resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

# Create the IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  
}

# Create Public Subnets
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(split(",", var.public_subnets_cidr))}"
  cidr_block              = "${element(split(",", var.public_subnets_cidr), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

}

output "public_subnets_id" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.public_subnets_cidr))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# Create the Private Subnets
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(split(",", var.private_subnets_cidr))}"
  cidr_block              = "${element(split(",", var.private_subnets_cidr), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = false

}

output "private_subnets_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.private_subnets_cidr))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

