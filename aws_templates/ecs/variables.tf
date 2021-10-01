variable "tag_name" {}
variable "tag_cost" {}

variable "ecs_host_cpu" {
  default = 256
}

variable "ecs_host_mem" {
  default = 512
}

#  variable "ecs_role" {}
variable "deploy_role" {}
variable "pvt_sbn" {}
variable "alb" {}
variable "alb_tgs" {}
variable "alb_listeners" {}
variable "sg_ecs" {}