module "iam" {
  source = "../iam"

  name = "${var.name}"
  iam_policy  = "${var.iam_policy}"
}

resource "aws_launch_configuration" "lc" {
  name_prefix          = "${var.name_prefix}"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${module.iam.profile_name}"
  user_data            = "${var.user_data}"
  ebs_optimized        = "${var.ebs_optimized}"
  enable_monitoring    = "${var.enable_monitoring}"

  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xvdf")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 500)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }
}
