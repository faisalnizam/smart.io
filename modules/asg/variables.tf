variable "max_size" {}
variable "min_size" {}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "block_device" {
  type = "map"

  default = {
    type                  = "EC2"
    delete_on_termination = true
  }
}

variable "vpc" {
    default = ""
}

variable "env" {
    default = ""
}
variable "role" {
    default = ""

}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "load_balancers" {
  type    = "list"
  default = []
}

variable "name_prefix" {}
variable "image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "enable_monitoring" {}
variable "name" {}
variable "iam_policy" {}

variable "iam_instance_profile" {
  default = ""
}

variable "user_data" {
  default = ""
}

variable "security_groups" {
  type    = "list"
  default = []
}

variable "ebs_optimized" {
  default = "false"
}

variable "internal" {
  description = "Determines if the ELB is internal or not"
  default     = false
}
