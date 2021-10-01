resource "aws_iam_role" "deploy_role" {
  name = "deploy_for_ecs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"

  role       = aws_iam_role.deploy_role.name
}


# resource "aws_iam_role" "ecs_role" {
#   description = "ecs task execute role"
#   name = "ecs_role"

# assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })



#   tags = {
#     Name = var.tag_name
#     Cost = var.tag_cost
#   }
# }

# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.ecs_role.name
# #   policy_arn = aws_iam_policy.policy.arn
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }