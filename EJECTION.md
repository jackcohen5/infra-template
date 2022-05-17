1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. Set the `TF_VAR_email_template` environment variable with the email format you would like to use for each environment account. ie. `TF_VAR_email_template=template_%s@example.com`

3. Set the `TF_VAR_github_repo` environment variable with the repo. ie. `TF_VAR_github_repo=jackcohen5/be-template`