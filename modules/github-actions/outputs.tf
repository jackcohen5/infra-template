output "github_role_arn" {
    value = aws_iam_role.github_role.arn
}

output "github_identity_provider_arn" {
    value = aws_iam_openid_connect_provider.github_oidc.arn
}