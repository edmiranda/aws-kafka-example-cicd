resource "aws_iam_role" "main" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "eks-fargate-pods.amazonaws.com",
              "eks.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = var.name
  path                  = "/"
  tags = {
    "Name" = var.name
  }
}

resource "aws_iam_role_policy" "main" {
  name = "${var.name}-policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "cloudwatch:PutMetricData",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.main.id
}

resource "aws_iam_role_policy_attachment" "ClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.main.id
}

resource "aws_iam_role_policy_attachment" "VPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.main.id
}


