
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

