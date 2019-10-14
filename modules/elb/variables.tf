variable "elb_name" {}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "security_groups" {
  type    = "list"
  default = []
}

variable "port" {
  description = "Instance port for http listner"
  default     = 80
}

variable "lb_port" {
  description = "Listener for the health_check for http listener"
  default     = 80
}

variable "https_port" {
  description = "Instance port for https listner"
  default     = 8080
}

variable "https_lb_port" {
  description = "Listener for the health_check for https listener"
  default     = 443
}

variable "health_check_url" {
  description = "The URL the ELB should use for health checks"
  default     = "TCP:22"
}

variable "internal" {
  description = "Determines if the ELB is internal or not"
  default     = false
}

variable "ssl_certificate_id" {
  description = "The ARN of the SSL Certificate in EC2"
}

variable "backend_protocol" {
  description = "The protocol the backend service speaks"
  default     = "http"
}

variable "instance_id" {
  description = "Temp variable fo testing"
  default     = ""
}
