plugin "terraform" {
    enabled = true
    version = "0.6.0"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

rule "terraform_standard_module_structure" {
  enabled = false
}

rule "terraform_unused_required_providers" {
  enabled = false
}
