terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.12.1"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region  = "us-east-1"
}

provider "tls" {}

resource "aws_organizations_organization" "org" {}

resource "aws_organizations_organizational_unit" "template" {
    name      = "template"
    parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "account" {
    count = length(var.environments)
    name  = format("%s Environment", var.environments[count.index])
    email  = format(var.email_template, var.environments[count.index])
    parent_id = aws_organizations_organizational_unit.template.arn
}