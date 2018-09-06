
source ./_log.sh

shell::GetFileName()
{
  #Usage: GetFileName <in:path>
  local in_path="$1"
  local file_name="${in_path##*/}"
  echo "${file_name}"
}

shell::NormalizePath()
{
  #Usage: NormalizePath <in:path>
  local in_path="$1"

  local real_path=$(realpath "${in_path}")
  echo "${real_path}"
}

shell::ConvertLinuxPathToWindowsPath()
{
  # Usage: ConvertLinuxPathToWindowsPath <in:path>
  local in_path=$1
  in_path=${in_path/\/mnt\//}
  in_path=${in_path/\//:\/}
  echo "${in_path}"
  return 0
}
