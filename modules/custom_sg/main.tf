resource "aws_security_group" "custom_sg" {
  name   = "${var.name}-custom_sg"
  vpc_id = "${var.vpc_id}"

ingress {
    from_port = 0 
    to_port =-0 
    protocol = -1 
    cidr_blocks     = ["0.0.0.0/0"]
}


egress  {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
}


}
