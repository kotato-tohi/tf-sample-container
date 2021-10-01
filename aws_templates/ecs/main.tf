resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_name}-cl"

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.tag_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_host_cpu
  memory                   = var.ecs_host_mem
  container_definitions    = <<TASK_DEFINITION
[
    {
        "cpu": 0,
        "essential": true,
        "image": "httpd:2.4",
        "memory": 128,
        "name": "apache",
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    }
]
TASK_DEFINITION
  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}


resource "aws_ecs_service" "ecs_service" {
  name = "${var.tag_name}-service"

  # https://github.com/hashicorp/terraform-provider-aws/issues/4657
  # iam_role        = var.ecs_role.arn

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # 当該ECSサービスを配置するECSクラスターの指定
  cluster = aws_ecs_cluster.ecs_cluster.name

  # データプレーンとしてFargateを使用する
  launch_type = "FARGATE"

  # ECSタスクの起動数を定義
  desired_count = "1"

  # 起動するECSタスクのタスク定義
  task_definition = aws_ecs_task_definition.ecs_task.arn

  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    # タスクの起動を許可するサブネット
    # subnets         =  ["${var.pub_sbn[0].id}"]
    subnets = [for l in var.pvt_sbn : l.id]
    # タスクに紐付けるセキュリティグループ
    security_groups = ["${var.sg_ecs.id}"]
  }

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = var.alb_tgs[0].arn
    container_name   = "apache"
    container_port   = 80
  }

  # deployやautoscaleで動的に変化する値を差分だしたくないので無視する
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer,
    ]
  }
}


resource "aws_codedeploy_app" "deploy_app" {
  compute_platform = "ECS"
  name             = "${var.tag_name}-app"
}


resource "aws_codedeploy_deployment_group" "deploy_group" {
  app_name               = aws_codedeploy_app.deploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.tag_name}-deploy-group"
  service_role_arn       = var.deploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 60
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    service_name = aws_ecs_service.ecs_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listeners[0].arn]
      }

      test_traffic_route {
        listener_arns = [var.alb_listeners[1].arn]
      }

      target_group {
        name = var.alb_tgs[0].name
      }

      target_group {
        name = var.alb_tgs[1].name
      }
    }
  }
}