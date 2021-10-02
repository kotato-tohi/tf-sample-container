variable "env_tag" {
  default = "dev"
}
variable "profile" {}
variable "region" {
  default = "ap-northeast-1"
}
variable "tag_name" {}
variable "tag_cost" {}

variable "az_list" {
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d"
  ]
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns" {}
variable "sbn_cnt" {}
variable "myip" {}
# variable "cert_arn" {}