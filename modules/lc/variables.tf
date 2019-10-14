variable "name_prefix" {}
variable "image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "enable_monitoring" {}
variable "name" {}
variable "iam_policy" {

default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "S3:*"
                  "ec2:DescribeInstances",
                  "ec2:AttachVolume",
                  "cloudwatch:ListMetrics",
                  "cloudwatch:GetMetricStatistics",
                  "ec2:DescribeVolumeAttribute",
                  "ec2:DescribeVolumeStatus",
                  "ec2:DescribeVolumes"
              ],
              "Resource": [ "*" ]
          }
      ]
}
EOF
}
variable "block_device" {
  type = "map"

  default = {
    type                  = "EBS"
    delete_on_termination = true
  }
}

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
