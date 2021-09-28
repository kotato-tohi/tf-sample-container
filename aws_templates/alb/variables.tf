variable "tag_name"{}
variable "tag_cost"{}
variable "sg_alb"{}
variable "pub_sbn"{}
variable "vpc_id"{}
variable "tg_cnt"{
    default = 2
}
variable "cert_arn"{}

variable "listrn_port_list"{
    default = ["443", "4430"]
}