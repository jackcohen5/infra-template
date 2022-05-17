variable "email_template" {
    description = "Email format to use for IAM environment accounts"
    type        = string
}

variable "environments" {
    description = "Environments to create IAM accounts"
    type        = list(string)
    default     = ["development", "staging", "production"]
}
