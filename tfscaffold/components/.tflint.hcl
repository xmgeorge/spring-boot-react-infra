# Disable unused locals
rule "terraform_unused_declarations" {
  enabled = false
}

# Disable missing version constraint for modules
rule "terraform_module_version" {
  enabled = false
}

# Disable missing version constraints for providers
rule "terraform_required_providers" {
  enabled = false
}
