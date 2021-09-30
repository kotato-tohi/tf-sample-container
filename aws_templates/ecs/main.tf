resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_name}-cl"

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.tag_name}-task"
	requires_compatibilities = ["FARGATE"]
	network_mode = "awsvpc"
	cpu    = var.ecs_host_cpu
  memory = var.ecs_host_mem
  container_definitions = <<TASK_DEFINITION
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
  cluster = "${aws_ecs_cluster.ecs_cluster.name}"

  # データプレーンとしてFargateを使用する
  launch_type = "FARGATE"

  # ECSタスクの起動数を定義
  desired_count = "1"

  # 起動するECSタスクのタスク定義
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"

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
    target_group_arn = "${var.alb_tgs[0].arn}"
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