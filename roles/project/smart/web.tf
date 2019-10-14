module "custom_sg" {
  name    = "${var.name}"
  source  = "../../../modules/custom_sg"
  vpc_id  = "${module.vpc_subnets.vpc_id}"
  ingress = "${var.ingress}"
  egress  = "${var.egress}"

  tags = "${merge(var.web_tags, map("Name", format("%s", var.name)))}"
}

module "elb" {
  source             = "../../../modules/elb"
  elb_name           = "${var.elb_name}"
  subnet_ids         = ["${module.vpc_subnets.public_subnets_id}"]
  security_groups    = "${module.custom_sg.custom_sg_id}"
  internal           = "${var.internal}"
  ssl_certificate_id = ""

  backend_protocol = "${var.backend_protocol}"
}

module "asg-module" {
  source               = "../../../modules/asg"
  name                 = "${var.name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  vpc_zone_identifier  = ["${module.vpc_subnets.private_subnets_id}"]
  name_prefix          = "${var.name_prefix}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = "${module.custom_sg.custom_sg_id}"
  iam_instance_profile = "${var.iam_instance_profile}"
  enable_monitoring    = true
  load_balancers       = ["${module.elb.elb_name}"]
  user_data            = "${data.template_file.launch_web.template}"

  iam_policy = <<EOF
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
  vpc  = "${module.vpc_subnets.vpc_id}"
}

data "template_file" "launch_web" {
  template = "${file("${path.module}/templates/web.tpl")}"
}

