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
  echo "--xxx (-x) <name>: Config with parameter (Default: ${config_xxx})"
  echo "--yyy (-y) : Config without parameter"
  exit 1
}

GetConfiguration()
{
  echo "* $(basename "$0")"
  echo "- Configuration:"
  config_xxx="default_value_x"
  config_yyy="0"
  while [[ $# != 0 ]]; do
      case $1 in
          --xxx|-x)
            config_xxx="$2"
            echo "  xxx = ${config_xxx}"
            shift 2
            ;;
          --yyy|-y)
            config_yyy="1"
            echo "  yyy = ${config_yyy}"
            shift 1
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

