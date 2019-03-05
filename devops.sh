#!/usr/bin/env bash

# Functions

Init()
{
  # Setup - Go to the directory where the bash file is
  g_script_name="$(basename "$0")"
  g_caller_dir=$(pwd)
  cd "$(dirname "$0")"
  g_script_dir=$(pwd -P)

  # Load dependencies
  source ./_log.sh
  source ./_devops.sh

  log::Init
}

End()
{
  log::Log "info" "5" "Returning to caller directory" "${g_caller_dir}"
  log::End
  cd "${g_caller_dir}"
}

ErrorHandler()
{
  # Usage: ErrorHandler <last_line>
  local last_line=$1
  log::Log "error" "1" "Last line executed" "${last_line}"
  End
  exit 1
}

DisplayHelp()
{

  echo "${g_script_name/.sh/} --<options> --<command> [<command_options>]"
  echo " "
  echo "- Options:"
  echo "--log_enable (-le) : Enable log"
  echo "--log_show (-ls) : Show log"
  echo "--log_level (-ll) <level>: Define the Log Level (Default: $(log::level))"
  echo " "
  echo "- Commands:"
  echo "--help (h) : Display this command help"
  echo "--setup_scripts (-ss) : Create the scripts callers and profile."
  echo "--setup_wsl (-ws) : Prepare the WSL have the proper intallation, configuration and mappings"
  echo "--jenkins_server_start (-js) : Start Jenkins Server"
  echo "--artifactory_server_start (-as) : Start JFrog Artifactory Server (Conan Package Manager Repository)"
  echo "--builder_start (-bs): Start Builder (with Conan Client)"
  echo "--fn_server_start (-fs) : Start Fn Server"
  echo "--get_docker_run_command (-gr) <container> : Get the run command of a container. You can inform the container name or id."
  echo "--execute_on_windows (-we) <command> : Run using Windows shell command"
  echo "--convert_to_window_path (-wp) <path> : Convert Linux path to Windows path. E.g.: devops -wp \$(pwd -P)" 
  echo "--bootstrap (-bo) <project_type> <project_path> : Bootstrap projects. E.g.: devops -bo cpp ~/temp/cpp_project" 
  echo " "
}

Main()
{
  while [[ $# != 0 ]]; do
      case $1 in
          --log_enable|-le)
            log::enable_log "true"
            shift 1
            ;;
          --log_show|-ls)
            log::show_log "true"
            shift 1
            ;;
          --log_level|-ll)
            log::level "$2"
            shift 2
            ;;
          --)
              shift
              break
              ;;
          --help|-h)
              DisplayHelp
              exit
              ;;
          --setup_scripts|-ss)
              devops::SetupScripts
              break
            ;;
          --setup_wsl|-ws)
              devops::SetupWSL
              break
            ;;
          --jenkins_server_start|-js)
              devops::StartJenkinsServerCommand
              break
            ;;
          --artifactory_server_start|-as)
              devops::StartArtifactoryServerCommand
              break
            ;;
          --builder_start|-bs)
              devops::StartBuilder
              break
            ;;
          --fn_server_start|-fs)
              devops::StartFnServerCommand
              break
            ;;
          --get_docker_run_command|-gr)
              devops::GetDockerRunCommand "$2"
              break
            ;;
          --execute_on_windows|-we)
              shift 1
              devops::ExecuteOnWindows "$@"
              break
            ;;
          --convert_to_window_path|-wp)
              shift 1
              devops::ConvertToWindowsPath "$2"
              break
            ;;
          --bootstrap|-bo)
              shift 1
              devops::Bootstrap "$1" "$2"
              break
            ;;
          -*)
              log::Log "error" "1" "Unknown option" "$1"
              DisplayHelp
              exit
              ;;
          *)
              break
              ;;
      esac
  done
}

# Main

set -E
trap 'ErrorHandler $LINENO' ERR

Init
Main "$@"
End

