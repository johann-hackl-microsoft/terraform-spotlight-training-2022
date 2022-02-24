locals {
    stage = replace(path_relative_to_include(), "stages/", "")
}

inputs = {
    stage = local.stage
    tg_rg_lifecycle_ignore_changes = (local.stage == "int" ? "tags, " : "")
}

terraform {
  before_hook "before_hook_1" {
    commands     = ["apply", "plan"]
    execute      = ["powershell", "Get-ChildItem env:"]
  }
}