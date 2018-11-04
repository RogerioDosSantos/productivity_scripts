
source ./_log.sh

wsl::PrepareDocker()
{
  # Usage: PrepareDocker

  # Fix drive paths for volume mount
  if mount | grep -w "/c" > /dev/null; then
    echo "/c driver already mounted"
  else
    echo "Mounting /c driver"
    sudo mkdir -p /c
    sudo mount --bind /mnt/c /c
  fi
}

wsl::Execute()
{
  # Usage: Execute <in:program_path> [<parameters>...]

  local shell_command="cmd.exe /C $@"
  log::Log "info" "5" "Shell Command" "${shell_command}"
  cmd.exe /C $@

  return 0
}

wsl::GetShortNamePath()
{
  # Usage: GetShortNamePath <in:windows_file_path>
  local in_windows_file_path="$1"

  local shell_command="cmd.exe /C _windows_short_name_path.bat "${in_windows_file_path}""
  log::Log "info" "5" "Shell Command" "${shell_command}"

  cmd.exe /C _windows_short_name_path.bat "${in_windows_file_path}"
}

wsl::ConvertLinuxPathToWindowsPath()
{
  # Usage: ConvertLinuxPathToWindowsPath <in:path>
  local in_path=$1
  in_path=${in_path/\/mnt\//}
  in_path=${in_path/\//:\/}
  in_path=$(wsl::GetShortNamePath "${in_path}")
  echo "${in_path}"
  return 0
}

