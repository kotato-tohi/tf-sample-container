variable "tag_name" {}
variable "tag_cost" {}

variable "ecs_host_cpu"{
    default = 256
}

variable "ecs_host_mem"{
    default = 512
}

#  variable "ecs_role" {}
variable "pvt_sbn" {}
variable "alb_arn" {}
variable "sg_ecs"{}
variable "alb_tgs" {}