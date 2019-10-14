module "lc" {
  source               = "../lc"
  name_prefix          = "${var.name_prefix}"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = "${var.security_groups}"
  iam_instance_profile = "${var.iam_instance_profile}"
  ebs_optimized        = "${var.ebs_optimized}"
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${var.user_data}"
  name                 = "${var.name}"
  block_device         = "${var.block_device}"
  iam_policy           = "${var.iam_policy}"
}

resource "aws_autoscaling_group" "asg" {
  max_size                  = "${var.max_size}"
  vpc_zone_identifier       = "${var.vpc_zone_identifier}"
  min_size                  = "${var.min_size}"
  force_delete              = true
  health_check_grace_period = "30"
  launch_configuration      = "${module.lc.name}"
  health_check_type         = "EC2"
  load_balancers            = "${var.load_balancers}"
  name                      = "${var.name}"

}
