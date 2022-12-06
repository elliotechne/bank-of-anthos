resource "aws_iam_policy" "node_additional" {
  name        = "EKSAdditional"
  description = "Example usage of node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
           "elasticfilesystem:ClientMount",
           "elasticfilesystem:ClientWrite",
           "elasticfilesystem:DescribeMountTargets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
