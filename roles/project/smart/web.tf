module "custom_sg" {
  name    = "${var.name}"
  source  = "../../../modules/custom_sg"
  vpc_id  = "${var.vpc_id}"
  ingress = "${var.ingress}"
  egress  = "${var.egress}"

  tags = "${merge(var.web_tags, map("Name", format("%s", var.name)))}"
}

module "elb" {
  source          = "../../../modules/elb"
  elb_name        = "${var.elb_name}"
  subnet_ids      = ["${var.vpc_zone_identifier_pub}"]
  security_groups = ["${module.custom_sg.custom_sg_id}"]
  internal        = "${var.internal}"

  backend_protocol   = "${var.backend_protocol}"
  ssl_certificate_id = "${var.ssl_certificate_id}"
}

module "asg-module" {
  source               = "../../../modules/asg"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  vpc_zone_identifier  = ["${var.vpc_zone_identifier}"]
  asg_name             = "${var.asg_name}"
  name_prefix          = "${var.name_prefix}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${module.custom_sg.custom_sg_id}"]
  iam_instance_profile = "${var.iam_instance_profile}"
  enable_monitoring    = true
  load_balancers       = ["${module.elb.elb_name}"]
  block_device         = "${var.block_device}"
  user_data            = "${data.template_file.launch_web.template}"
  name                 = "${var.name}"

  "iam_policy" = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
                {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "s3:*",
                "elasticfilesystem:*",
                "kms:*",
                "es:*",
                "ecr:*",
                "dynamodb:*",
                "sqs:*",
                "cloudwatch:*",
                "cloudformation:*"
            ],
            "Resource": [ "*" ]
        }
        ]
}
EOF

  role = "Web"
  env  = "iac"
  vpc  = "${var.vpc_id}"
  name = "web.${var.vpc_id}.iac"
} // Auto Scaling Group Ends Here

data "template_file" "launch_web" {
  vars {
    playbook_name = "${var.playbook}"
    index_value = "${count.index}"
  }

  template = "${file("${path.module}/templates/web.tpl")}"
}

resource "aws_route53_record" "route53" {
  zone_id = "${var.zone_id}"
  name    = "${var.dns_address}"
  type    = "${var.record_type}"
  ttl     = "10"
  records = ["${module.elb.elb_dns_name}"]
}

