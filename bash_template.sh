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
  echo "--help (-h) : Display this command help"
  echo "--xxx (-n) <name>: Name of the Workspace (Default: ${config_xxx})"
  exit 1
}

GetConfiguration()
{
  echo "* $(basename "$0")"
  echo "- Configuration:"
  config_xxx="workspace"
  while [[ $# != 0 ]]; do
      case $1 in
          --xxx|-n)
            config_xxx="$2"
            echo "  xxx = ${config_xxx}"
            shift 2
            ;;
          --)
              shift
              break
              ;;
          --help|-h)
              DisplayHelpAndExit
              exit
              ;;
          -*)
              echo "Unknown option $1"
              DisplayHelpAndExit
              exit
              ;;
          *)
              break
              ;;
      esac
  done
}

MainFunction()
{
  echo "- TODO: Add logic here"
}

Init
GetConfiguration "$@"
MainFunction
End

