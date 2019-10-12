variable "app_name" {
  default = "smart-devops-test"

}
variable "environment_name" {
  default = "smart"
}

variable "web_tags" {
  type = "map"

  default = {
    "smart:tier"        = "web"
    "smart:team"        = "devops-iac"
    "smart:criticality" = "high"
  }
}

variable "playbook" {
  default = "web"
}

variable "path_to_modules" {
  default = "../../../modules"
}

variable "iam_policy" {
  default = ""
}

variable "ingress" {
  description = "Specifies an ingress rule."

  default = [{
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "TCP"
    to_port     = "65535"
  },
    {
      from_port = "0"
      protocol  = "-1"
      to_port   = "0"
      self      = true
    },
  ]
}

variable "egress" {
  description = "Specifies an ingress rule."

  default = [{
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }]
}

variable "vpc_id" {}

variable "vpc_zone_identifier" {
  type = "list"
}

variable "vpc_zone_identifier_pub" {
  type = "list"
}

variable "elb_name" {
  default = "jenkins-elb"
}

variable "name" {
  default = "jenkins-im"
}

variable "internal" {
  default = "false"
}

variable "backend_protocol" {
  default = "http"
}

variable "ssl_certificate_id" {}

variable "source_cidr_block" {
  default = "0.0.0.0/0"
}

variable "max_size" {
  default = "1"
}

variable "min_size" {
  default = "1"
}

variable "asg_name" {
  default = "jenkins-immutable-iac"
}

variable "name_prefix" {
  default = "myconfig-jenkins"
}

variable "ami_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "iam_instance_profile" {
  default = "aws-elasticbeanstalk-ec2-role"
}


