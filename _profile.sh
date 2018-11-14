
profile::profile_file_path()
{
  if [ "$#" != 0 ]; then
    profile__profile_file_path="$1"
    log::Log "info" "5" "Enable Log" "$1"
    return 0
  fi

  echo "${profile__profile_file_path:-"${HOME}/.script_profile"}"
}

# profile::ParseYaml()
# {
#   local prefix=$2
#    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
#    sed -ne "s|^\($s\):|\1|" \
#         -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
#         -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
#    awk -F$fs '{
#       indent = length($1)/2;
#       vname[indent] = $2;
#       for (i in vname) {if (i > indent) {delete vname[i]}}
#       if (length($3) > 0) {
#          vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
#          printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
#       }
#    }'
# }

profile::GetValue()
{
  # Usage GetValue <in:profile_key> <in:default_value>
  local in_profile_key="$1"
  local in_default_value="$2"

  local profile_path="$(profile::profile_file_path)"
  if [ ! -f "${profile_path}"  ]; then
    echo "${in_profile_key}=${in_default_value}" >> ${profile_path}
  fi

	local value="$(cat ${profile_path} | grep ${in_profile_key})"
  if [ "${value}" == "" ]; then
    echo "${in_profile_key}=${in_default_value}" >> ${profile_path}
    echo "${in_default_value}"
  fi

  echo "${value#*=}"

}
