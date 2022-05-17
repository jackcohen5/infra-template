data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_oidc" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "github_allow" {
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRoleWithWebIdentity"]
        principals {
            type        = "Federated"
            identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
        }
        condition {
            test     = "StringLike"
            variable = "token.actions.githubusercontent.com:aud"
            values   = ["sts.amazonaws.com"]
        }
        condition {
            test     = "StringLike"
            variable = "token.actions.githubusercontent.com:sub"
            values   = [format("repo:%s:ref:refs/heads/master", var.github_repo)]
        }
    }
}

resource "aws_iam_role" "github_role" {
    name               = "GithubActionsRole"
    assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

data "aws_iam_policy_document" "github_actions_policy" {
    statement {
        actions = [
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject",
        ]
        effect = "Allow"
        resources = ["*"]
    }
}

resource "aws_iam_role_policy" "github_actions" {
    name   = "github-actions"
    role   = aws_iam_role.github_role.id
    policy = data.aws_iam_policy_document.github_actions_policy.json
}