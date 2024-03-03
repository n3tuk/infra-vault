locals {
  environment = lookup(local.environment_names, element(split(".", terraform.workspace), 1), "unknown")

  environment_names = {
    p = "production"
    d = "development"
    t = "testing"
    s = "services"
  }
}
