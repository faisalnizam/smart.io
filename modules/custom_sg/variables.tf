variable "name" {
  default = "test"
}

variable "environment" {
  default = "test"
}

variable "vpc_id" {
  description = "The VPC this security group will go in"
}

variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default     = ""
}

# variable "from_port" {
#   description = "The From Port"
# }

# variable "to_port" {
#   description = "The To Port"
# }

variable "tags" {
  default = {}
}

variable "ingress" {
  default = []
}

variable "egress" {
  default = []
}
