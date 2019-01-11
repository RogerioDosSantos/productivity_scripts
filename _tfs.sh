
source ./_log.sh
source ./_shell.sh
source ./_wsl.sh

tfs::program_path()
{
  if [ "$#" != 0  ]; then
    tfs__program_path="$1"
    log::Log "info" "5" "TFS Program Path" "$1"
    return 0
  fi

  # local short_program_path="${tfs__program_path:-"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\IDE\\tf.exe"}"
  # short_program_path=$(wsl::GetShortNamePath "${short_program_path}")
  # echo "${short_program_path}"
  
  echo "${tfs__program_path:-"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\IDE\\tf.exe"}"
  return 0
}

tfs::Checkout()
{
  #Usage: Checkout <in:file_path>
  local in_file_path="$1"
  log::Log "info" "5" "Checkin out file" "${in_file_path}"

  local file_name="$(shell::GetFileName "${in_file_path}")"
  local file_path="$(shell::NormalizePath "${in_file_path}")"
  log::Log "info" "5" "Normalized Path" "${file_path}"

  local windows_file_path="$(wsl::ConvertLinuxPathToWindowsPath "${file_path}")"
  log::Log "info" "5" "Windows File Path" "${windows_file_path}"

  local result="$(wsl::Execute "_tfs.bat" -co "${windows_file_path}" | grep "${file_name}" | tr -d '[:space:]')"
  log::Log "info" "5" "Checkout result" "${result}"
  log::Log "info" "5" "Checkout expected result" "${file_name// /}"
  if [ "${result}" == "${file_name// /}" ]; then
    echo "true"
    return 0
  fi

  echo "false"
  return 0
}

tfs::CheckoutCommand()
{
  #Usage: CheckoutCommand <in:file_path>
  local in_file_path="$1"
  if [ "$(tfs::Checkout "${in_file_path}")" == "true" ]; then
    echo "${in_file_path} - checkout success"
  else
    echo "${in_file_path} - checkout failure"
  fi

  return 0
}

tfs::History()
{
  #Usage: History <in:file_path>
  local in_file_path="$1"
  log::Log "info" "5" "Getting history of the following file" "${in_file_path}"

  local file_name="$(shell::GetFileName "${in_file_path}")"
  local file_path="$(shell::NormalizePath "${in_file_path}")"
  local windows_file_path="$(wsl::ConvertLinuxPathToWindowsPath "${file_path}")"
  log::Log "info" "5" "Windows File Path" "${windows_file_path}"

  wsl::Execute "_tfs.bat" -hs "${windows_file_path}"
  return 0
}

tfs::CheckoutList()
{
  #Usage: CheckoutList <collection_url>
  local in_collection_url=$1
  log::Log "info" "5" "List of checkout files" ""

  wsl::Execute "_tfs.bat" -cl "${in_collection_url}"
}


