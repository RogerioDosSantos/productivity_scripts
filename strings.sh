
#!/bin/bash

# Functions

Init()
{
  # Setup - Go to the directory where the bash file is
  g_script_name="$(basename "$0")"
  g_caller_dir=$(pwd)
  cd "$(dirname "$0")"
  g_script_dir=$(pwd)

  # Load dependencies
  source ./_log.sh
  source ./_strings.sh

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
  echo "${g_script_name/.sh/} --<command> [<command_options>]"
  echo " "
  echo "- Commands:"
  echo "--help (h) : Display this command help"
  echo "--log_enable (-le) : Enable log"
  echo "--log_show (-ls) : Show log"
  echo "--log_level (-ll) <level>: Define the Log Level (Default: $(log::level)"
  echo "--count_char (-cc) <text_to_search> <character_to_count>: Count the amount of characters into a text."
  echo "--is_integer (-ii) <text>: Check if a text is integer."
  echo "--is_number (-in) <text>: Check if a text is a number."

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
          --count_char|-cc)
              strings::CountCharacters "$2" "$3"
              break
            ;;
          --is_integer|-ii)
              strings::IsInteger "$2"
              break
            ;;
          --is_number|-in)
              strings::IsNumber "$2"
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

