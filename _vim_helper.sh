#/usr/bin/env bash

source ./_log.sh

vim_helper::GetInput()
{
  # Usage: GetInput <in:description> <in:default_value>
  local in_description="$1"
  local in_default_value="${2}"
  log::Log "info" "5" "Description" "${in_project_dir}"
  log::Log "info" "5" "Default Value" "${in_template_dir}"
  read -p "${in_description} [${in_default_value}]: " value
  echo "${value:-${in_default_value}}"
}

