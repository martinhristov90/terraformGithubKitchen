provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

resource "github_repository" "testRepo" {
  name        = "repositoryCreatedWithTerraform"
  description = "This repository is created by using Terraform GitHub provider"
}
