config {
    module = true
}

plugin "aws" {
  enabled = true
  version = "0.21.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  # version = "0.43.0"
  # source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}



# Disallow // comments in favor of #.
rule "terraform_comment_syntax" {
  enabled = true # 0 issues found
}

# Disallow legacy dot index syntax. [Recommended]
rule "terraform_deprecated_index" {
  enabled = true # 60 issues found
}

# Disallow deprecated (0.11-style) interpolation. [Recommended]
rule "terraform_deprecated_interpolation" {
  enabled = true # 1 error found
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
  enabled = true # 29 issues found
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
  enabled = true # 24 issues found
}

# Disallow comparisons with [] when checking if a collection is empty. [Recommended]
rule "terraform_empty_list_equality" {
  enabled = true # 0 issues found
}

# Disallow specifying a git or mercurial repository as a module source without pinning to a version. [Recommended]
rule "terraform_module_pinned_source" {
  enabled = true # 0 issues found
}

# Checks that Terraform modules sourced from a registry specify a version. [Recommended]
rule "terraform_module_version" {
  enabled = true # 0 issues found
}

# Enforces naming conventions
rule "terraform_naming_convention" {
  enabled = true # 0 issues found 
  custom = "^([a-zA-Z0-9])+([_-][a-zA-Z0-9]+)*$"
}

# Require that all providers have version constraints through required_providers. [Recommended]
rule "terraform_required_providers" {
  enabled = true  # 0 issues found
}

# Disallow terraform declarations without require_version. [Recommended]
rule "terraform_required_version" {
  enabled = true  # 0 issues found
}

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
  enabled = true # 0 issues found
}

# Disallow variable declarations without type. [Recommended]
rule "terraform_typed_variables" {
  enabled = true  # 28 issues found
}

# Disallow variables, data sources, and locals that are declared but never used. [Recommended]
rule "terraform_unused_declarations" {
  enabled = true # 4 issues found
}

# Check that all required_providers are used in the module.
rule "terraform_unused_required_providers" {
  enabled = true # 4 issues found
}

# terraform.workspace should not be used with a "remote" backend with remote execution. [Recommended]
rule "terraform_workspace_remote" {
  enabled = true # 0 issues found
}