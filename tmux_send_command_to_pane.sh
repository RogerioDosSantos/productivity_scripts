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
  echo "--help (-h) : Display this command help"
  echo "--pane_id (-p) <id>: Id of the pane (Default: ${config_pane_id})"
  echo "--command (-c) <command>: Command to be sent (Default: ${config_command}: Display pane IDs)"
  exit 1
}

GetConfiguration()
{
  echo "* $(basename "$0")"
  echo "- Configuration:"
  config_pane_id="1"
  config_command="tmux display-pane"
  while [[ $# != 0 ]]; do
      case $1 in
          --pane_id|-i)
            config_pane_id="$2"
            echo "  pane_id = ${config_pane_id}"
            shift 2
            ;;
          --command|-c)
            config_command="$2"
            echo "  command = ${config_command}"
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
  echo "- Sending pane command" 
  tmux send-keys -t ${config_pane_id} "${config_command}" C-m
}

Init
GetConfiguration "$@"
MainFunction
End

