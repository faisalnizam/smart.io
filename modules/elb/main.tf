resource "aws_elb" "elb" {
  name                        = "${var.elb_name}"
  subnets                     = "${var.subnet_ids}"
  internal                    = "${var.internal}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = "${var.port}"
    instance_protocol = "http"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "http"
  }


  listener {
    instance_port     = 8081
    instance_protocol = "http"
    lb_port           = 8081
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    target              = "${var.health_check_url}"
    interval            = 30
  }

}
