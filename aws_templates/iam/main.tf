resource "aws_iam_role" "ecs_ecex_role" {
  name = "ecs_ecex_role"

  assume_role_policy = jsonencode({
    "family": "test",
    "executionRoleArn": "arn:aws:iam::xxxxxxxx:role/ecsTaskExecutionRole",
    "networkMode": "awsvpc",
    "containerDefinitions": [
        {
            "name": "test-nginx",
            "image": "nginx:latest",
            "ulimits": [
                {
                    "name": "nofile",
                    "softLimit": 65536,
                    "hardLimit": 65536
                }
            ],
            "entryPoint": [
                "sh",
                 "-c"
            ],
            "portMappings": [
                {
                    "hostPort": 80,
                    "protocol": "tcp",
                    "containerPort": 80
                }
            ],
            "command": [
                "echo blue > /usr/share/nginx/html/index.html | /usr/sbin/nginx -g \"daemon off;\""
            ],
            "memoryReservation": 256,
            "essential": true,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/test-nginx",
                    "awslogs-region": "ap-northeast-1",
                    "awslogs-stream-prefix": "test-nginx"
                }
            }
        }
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "512",
    "memory": "4096",
})


  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}