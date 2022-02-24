terraform {
  source = "../../src"

  before_hook "before_hook_1" {
    commands     = ["apply", "plan"]
    execute      = ["PowerShell", ". ${get_terragrunt_dir()}/../../util/replace-inputs.ps1"]
  }    
}

locals {
    stage = replace(path_relative_to_include(), "stages/", "")
}

inputs = {
    stage = local.stage
    tg_rg_lifecycle_ignore_changes = (local.stage == "int" ? "tags, " : "")
}
