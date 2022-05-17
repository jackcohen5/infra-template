output "environment_account_arns" {
  value       = aws_organizations_account.account[*].arn
  description = "The account ARNs for all environments"
}
