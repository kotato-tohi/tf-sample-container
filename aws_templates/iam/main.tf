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