#!/bin/bash

# WARNING: Please DO NOT edit this file! It is maintained in the Repository Template (https://github.com/nhs-england-tools/repository-template). Raise a PR instead.

set -euo pipefail

# A set of Terraform functions written in Bash.
#
# Usage:
#   $ source ./terraform.lib.sh

# ==============================================================================
# Common Terraform functions.

# Initialise Terraform.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform init command, default is none/empty]
function terraform-init() {

  _terraform init # 'dir' and 'opts' are passed to the function as environment variables, if set
}

# Plan Terraform changes.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform plan command, default is none/empty]
function terraform-plan() {

  _terraform plan # 'dir' and 'opts' are passed to the function as environment variables, if set
}

# Apply Terraform changes.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform apply command, default is none/empty]
function terraform-apply() {

  _terraform apply # 'dir' and 'opts' are passed to the function as environment variables, if set
}

# Destroy Terraform resources.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform destroy command, default is none/empty]
function terraform-destroy() {

    _terraform apply -destroy # 'dir' and 'opts' are passed to the function as environment variables, if set
}

# Format Terraform code.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform fmt command, default is '-recursive']
function terraform-fmt() {
  for d in "${PWD}infrastructure/"*; do
    if [ -d "$d" ]; then
        terraform fmt --recursive "${d}"
    fi
  done
}

# Validate Terraform code.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
#   opts=[options to pass to the Terraform validate command, default is none/empty]
function terraform-validate() {

  _terraform validate # 'dir' and 'opts' are passed to the function as environment variables, if set
}

# shellcheck disable=SC2001,SC2155
function _terraform() {

  local dir="$(echo "${dir:-$PWD}" | sed "s#$PWD#.#")"
  local cmd="-chdir=$dir $* ${opts:-}"
  local project_dir="$(git rev-parse --show-toplevel)"

  cmd="$cmd" "$project_dir/scripts/terraform/terraform.sh"
}

# Remove Terraform files.
# Arguments (provided as environment variables):
#   dir=[path to a directory where the command will be executed, relative to the project's top-level directory, default is '.']
function terraform-clean() {

  (
    cd "${dir:-$PWD}"
    rm -rf \
      .terraform \
      terraform.log \
      terraform.tfplan \
      terraform.tfstate \
      terraform.tfstate.backup
  )
}
