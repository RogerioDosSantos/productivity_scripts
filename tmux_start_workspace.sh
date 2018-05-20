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
  echo "--workspace_name (-n) <name>: Name of the Workspace (Default: ${config_workspace_name})"
  echo "--left_size_percentage (-sl) <size> : Size of the left pane in % (Default: ${config_left_size_percentage})"
  echo "--down_size_percentage (-sd) <size> : Size of the down pane in % (Default: ${config_down_size_percentage})"
  echo "--left_program_command (-cl) <command> : Command to be send to the left pane (Default: ${config_left_program_command})"
  echo "--main_program_command (-cm) <command> : Command to be send to the main pane (Default: ${config_main_program_command})"
  echo "--close_current_window (-cw) : Close the current window."
  exit 1
}

GetConfiguration()
{
  echo "* $(basename "$0")"
  echo "- Configuration:"
  config_workspace_name="workspace"
  config_left_size_percentage="30"
  config_left_program_command="vim ~/wiki/docs/src/index.md"
  config_down_size_percentage="30"
  config_main_program_command="vim"
  config_close_current_window="0"
  while [[ $# != 0 ]]; do
      case $1 in
          --workspace_name|-n)
            config_workspace_name="$2"
            echo "  workspace_name = ${config_workspace_name}"
            shift 2
            ;;
          --left_size_percentage|-sl)
            config_left_size_percentage="$2"
            echo "  left_size_percentage = ${config_left_size_percentage}"
            shift 2
            ;;
          --down_size_percentage|-sd)
            config_down_size_percentage="$2"
            echo "  down_size_percentage = ${config_down_size_percentage}"
            shift 2
            ;;
          --left_program_command|-cl)
            config_left_program_command="$2"
            echo "  left_program_command = ${config_left_program_command}"
            shift 2
            ;;
          --main_program_command|-cm)
            config_main_program_command="$2"
            echo "  main_program_command = ${config_main_program_command}"
            shift 2
            ;;
          --close_current_window|-cw)
            config_close_current_window="1"
            echo "  close_current_window = ${config_close_current_window}"
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
  echo "- Creating Workspace:"
  tmux new-window -n ${config_workspace_name} -d
  tmux send-keys -t ${config_workspace_name} "tmux split-window -h -d -p ${config_left_size_percentage}" C-m
  tmux send-keys -t ${config_workspace_name} "tmux send-keys -t 1 \"${config_left_program_command}\" C-m" C-m
  tmux send-keys -t ${config_workspace_name} "tmux split-window -d -p ${config_down_size_percentage}" C-m
  tmux send-keys -t ${config_workspace_name} "${config_main_program_command}" C-m

  if [ ${config_close_current_window} = "1" ]; then
    tmux kill-window
  fi
}

Init
GetConfiguration "$@"
MainFunction
End

