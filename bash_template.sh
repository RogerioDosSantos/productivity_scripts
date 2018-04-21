#!/bin/bash

# # Ensure that run as root
# if [ "$EUID" -ne 0 ]
#   then echo "This program must be run with administrator privileges.  Aborting"
#   exit
# fi

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

XXX()
{
	echo "${config_xxx}"
}

GetConfiguration()
{
  configs[0]="xxx;x;default_value_x;help_description_x"
  configs[1]="yyy;y;default_value_y;help_description_y"

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

  if [ "$1" == "" ]; then DisplayHelpAndExit; fi
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

GetConfiguration "$@"

