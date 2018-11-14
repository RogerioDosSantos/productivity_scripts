
source ./_profile.sh

log::enable_log()
{
  if [ "$#" != 0 ]; then
    log__enable_log="$1"
    log::Log "info" "5" "Enable Log" "$1"
    return 0
  fi

  echo "${log__enable_log:-"$(profile::GetValue "log_enabled" false)"}"
}

log::show_log()
{
  if [ "$#" != 0 ]; then
    log__show_log="$1"
    log::enable_log 'true'
    log::Log "info" "5" "Show Log" "$1"
    return 0
  fi

  echo "${log__show_log:-"$(profile::GetValue "show_log" false)"}"
}

log::level()
{
  if [ "$#" != 0 ]; then
    log__level="$1"
    log::Log "info" "5" "Log Level" "$1"
    return 0
  fi

  echo "${log__level:-"$(profile::GetValue "log_level" 1)"}"
}

log::file_path()
{
  if [ "$#" != 0 ]; then
    log__file_path="$1"
    return 0
  fi

  echo "${log__file_path:-"./.log_$(date '+%Y-%m-%d')"}"
}

log::Init()
{
  return 0
}

log::End()
{
  log::ShowLog
}

log::Log()
{
  # Log <type> <level> <message> <detail>

  if [ "$(log::enable_log)" != "true" ]; then
    return 0
  fi

  local log_type=$1
  local log_level=$2
  if [[ "$(log::level)" < "${log_level}" ]]; then
    return 0
  fi

  local log_message=$3
  local log_detail=$4
  local log_date="$(date '+%Y-%m-%d %H:%M:%S')"
  local log_caller=${FUNCNAME[1]}
  local log_file_path="$(log::file_path)"

  echo "${log_date},${log_type},${log_level},${log_caller},${log_message},${log_detail}" >> "${log_file_path}"
}

log::ShowLog()
{
  if [ "$(log::show_log)" != "true" ]; then
    return 0
  fi

  echo " "
  echo "======= Log ======="
  local log_file_path="$(log::file_path)"
  if [ ! -f "${log_file_path}" ]; then
    return 0
  fi

  cat "$(log::file_path)"
  rm "$(log::file_path)"
}

log::ErrorHandler()
{
  # Usage: ErrorHandler <in:last_line>
  local last_line=$1
  log::Log "error" "1" "Last line executed" "${last_line}"
  for function_name in "${FUNCNAME[@]:1}"; do
    log::Log "error" "2" "Stack" "${function_name}"
	done
  End
  exit 1
}

log::GetActivity()
{
  # Usage GetActivity <in:command_id>
  local command_id=$1
  log::Log "info" "5" "command id" "${command_id}"
  echo "$LINENO - GetActivity ${command_id}" 
  sleep 5
  echo "$LINENO - GetActivity ${command_id}" 
  
}

