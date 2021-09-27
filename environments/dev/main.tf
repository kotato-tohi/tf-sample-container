terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

module "network" {
  source     = "./../../aws_templates/network/"
  cidr_block = var.cidr_block
  sbn_cnt    = var.sbn_cnt
  az_list    = var.az_list
  tag_name   = var.tag_name
  tag_cost   = var.tag_cost
  enable_dns = true
}
