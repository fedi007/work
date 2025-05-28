#data "aws_caller_identity" "current" {}
#data "aws_partition" "current" {}
#data "aws_region" "current" {}

//////// ASSUME ROLE FOR EKS SERVICE ///////
data "aws_iam_policy_document" "eks_assume_role_doc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "create_access_ssm_from_eks_policy_doc" {
  statement {
    effect = "Allow"
    actions = ["ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:GetParametersByPath",
    ]
    #resources = ["arn:aws:ssm:eu-west-3:567048421013:parameter/dev/*", ]
    resources = ["arn:aws:ssm:${var.eks_region}:${var.eks_account_id}:parameter/${var.env_name}/*", ]
  }
}

//////// ASSUME ROLE FOR EKS Node Group ///////
data "aws_iam_policy_document" "node_group_assume_role" {
  count = local.create_eks ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_openID_connect[0].arn]
      type        = "Federated"
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::185849290566:role/adad-infra-role"]
    }
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.eks_cluster_name
}
data "aws_eks_cluster_auth" "cluster_auth" {
  count = local.create_eks ? 1 : 0
  name  = aws_eks_cluster.eks[0].id
}

data "tls_certificate" "identity_oidc_issuer" {
  count = local.create_eks ? 1 : 0
  url   = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}

data "aws_subnet" "sbn" {
  id = var.eks_cluster_public_subnet_ids[0]
}

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.eks_version}/${local.ami_type}/recommended/image_id"
}

data "aws_iam_policy_document" "pod" {
  statement {
    sid    = "podS3Actions"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "codeartifact:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "podKmsActions"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "podSsmActions"
    effect = "Allow"
    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParameterHistory",
      "ssm:PutParameter",
      "ssm:DescribeParameters"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "podSecretManagerActions"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "podLambdaActions"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    sid    = "rdsActions"
    effect = "Allow"
    actions = [
      "rds:StopDBCluster*",
      "rds:StartDBCluster",
      "rds:DescribeDBClusters",
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:ListTagsForResource",

    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ecrActions"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "*"
    ]
  }



  statement {
    sid    = "ec2startstopActions"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:StartInstances",
      "ec2:DescribeTags",
      "ec2:StopInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",


    ]

    resources = [
      "*"
    ]
  }


  statement {
    sid    = "ec2Volume"
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "sts:AssumeRole"

    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ec2sts"
    effect = "Allow"
    actions = [
      "sts:GetServiceBearerToken"
    ]
    resources = [
      "*"
    ]
  }

}