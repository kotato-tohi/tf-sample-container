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

module "security" {
  source   = "./../../aws_templates/security"
  env_tag  = var.env_tag
  tag_name = var.tag_name
  tag_cost = var.tag_cost
  vpc_id   = module.network.vpc_id
  myip     = var.myip
}

module "iam" {
  source   = "./../../aws_templates/iam"
  tag_name = var.tag_name
  tag_cost = var.tag_cost
}

module "alb" {
  source   = "./../../aws_templates/alb"
  tag_cost = var.tag_cost
  tag_name = var.tag_name
  pub_sbn  = module.network.pub_sbn
  sg_alb   = module.security.sg_alb
  vpc_id   = module.network.vpc_id
  cert_arn = var.cert_arn
}


module "ecs" {
  source        = "./../../aws_templates/ecs"
  tag_cost      = var.tag_cost
  tag_name      = var.tag_name
  pvt_sbn       = module.network.pvt_sbn
  alb           = module.alb.alb
  alb_tgs       = module.alb.alb_tgs
  alb_listeners = module.alb.alb_listeners
  sg_ecs        = module.security.sg_ecs
  # ecs_role = module.iam.ecs_role
  deploy_role = module.iam.deploy_role
}