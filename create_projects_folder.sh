#!/bin/bash

# Exit on any non-zero status.
trap 'exit' ERR
set -E

# Functions

Init()
{
  # Setup - Go to the directory where the bash file is
  call_dir=$(pwd)
  cd "$(dirname "$0")"
  bash_dir=$(pwd)
  echo "- Called from ${call_dir}"
  echo "- Running from ${bash_dir}"
  cd "$(dirname "$0")"
}

End()
{
  # Setup - Return to the called directory
  cd "${call_dir}"
}

DisplayHelpAndExit()
{
	echo "Commands Help"
  for config in "${configs[@]}"; do
		IFS=";" read -r -a options <<< "${config}"
    echo "--${options[0]} or -${options[1]} : ${options[3]}"
	done
  exit 1
}

GetConfiguration()
{
  config_workspace_dir="$(readlink -f ~/roger)"
  config_project_dir="${call_dir}"
  configs[0]="workspace_dir;w;${config_workspace_dir};Workspace Directory."
  configs[1]="project_dir;l;${config_project_dir};Location where the work directory will be created"

  # Set values from user
  commands=()
  shortcuts=()
  variables=()
  for config in "${configs[@]}"; do
		IFS=";" read -r -a options <<< "${config}"
    commands+=("${options[0]}")
    shortcuts+=("${options[1]}")
    variable="config_${options[0]}"
    variables+=("${variable}")
    typeset $variable="${options[2]}"
	done

  # if [ "$1" == "" ]; then DisplayHelpAndExit; fi
  while [ "$1" != "" ]; do
    for index in "${!commands[@]}"; do
      if [ "$1" == "--${commands[index]}" ] || [ "$1" == "-${shortcuts[index]}" ]; then
        shift
        if [ -z "$1" ]; then
          DisplayHelpAndExit
        else
          variable="config_${commands[index]}"
          typeset $variable="$1"
        fi
        break
      fi
    done
  shift
done

  # Display Configuration
  echo "* $(basename "$0")"
  echo "- Configuration:"
  for index in "${!commands[@]}"; do
    variable="config_${commands[index]}"
    echo "  ${commands[index]} = ${!variable}"
  done
}

CreateProjectsFolder()
{
  echo "- Creating Project Folders"

  mkdir -p "${config_project_dir}"
  cp -n "${config_workspace_dir}/productivity/templates/git/gitignore_projects_folder" "${config_project_dir}/.gitignore"
  echo " " >> "${config_project_dir}/README.md"
  echo "For more information please look at the [documentation]( ./doc/src/index.md )" >> "${config_project_dir}/README.md"

  mkdir -p "${config_project_dir}/build"

  mkdir -p "${config_project_dir}/stage"

  mkdir -p "${config_project_dir}/doc"

  mkdir -p "${config_project_dir}/doc/src"
  echo " " >> "${config_project_dir}/doc/src/index.md"

  mkdir -p "${config_project_dir}/doc/stage"

  mkdir -p "${config_project_dir}/doc/resources"
  cp -n "${config_workspace_dir}/productivity/templates/pandoc/wiki_style.css" "${config_project_dir}/doc/resources/style.css"
}

Init
GetConfiguration "$@"
CreateProjectsFolder
End

