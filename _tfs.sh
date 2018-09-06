
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

  echo "${tfs__program_path:-"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\IDE\\tf.exe"}"
}

tfs::Checkout()
{
  #Usage: Checkout <in:file_path>
  local in_file_path="$1"
  log::Log "info" "5" "Checkin out file" "${in_file_path}"

  local file_name="$(shell::GetFileName "${in_file_path}")"
  local file_path="$(shell::NormalizePath "${in_file_path}")"
  local windows_file_path="$(shell::ConvertLinuxPathToWindowsPath "${file_path}")"
  log::Log "info" "5" "Windows File Path" "${windows_file_path}"

  local result="$(wsl::Execute "$(tfs::program_path)" "vc" "checkout" "${windows_file_path}" | grep "${file_name}" | tr -d '[:space:]')"
  if [ "${result}" == "${file_name}" ]; then
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

