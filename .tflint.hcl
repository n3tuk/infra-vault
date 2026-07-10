config {
  format     = "default"
  plugin_dir = "~/.tflint.d/plugins"
}

plugin "terraform" {
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.15.0"
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

# Using main.tf is not always the best option for managing resources and data
# sources within larger modules and Terraform configurations
rule "terraform_standard_module_structure" {
  enabled = false
}

# tflint cannot always traverse included Terraform Modules, which means it may
# not be aware of provider usage within Modules and so report a false negative
rule "terraform_unused_required_providers" {
  enabled = false
}

plugin "google" {
  source  = "github.com/terraform-linters/tflint-ruleset-google"
  version = "0.39.0"
  enabled = true

# Recommends using available ephemeral resources instead of the original data source. Valid for Terraform v1.10+.
  deep_check = false
}

plugin "aws" {
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.48.0"
  enabled = true

  # Deep checking uses credentials to perform a more strict inspection, but it can be slow and may cause side effects
  deep_check = false
}

# Recommends using available ephemeral resources instead of the original data source. Valid for Terraform v1.10+.
rule "aws_ephemeral_resources" {
  enabled = true
}

# Disallow using deprecated policy attributes of aws_iam_role
rule "aws_iam_role_deprecated_policy_attributes" {
  enabled = true
}

# Disallow ingress and egress arguments of the aws_security_group resource
rule "aws_security_group_inline_rules" {
  enabled = true
}

# Disallow using aws_security_group_rule resource
rule "aws_security_group_rule_deprecated" {
  enabled = true
}
