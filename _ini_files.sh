
ini::GetProperty()
{
  # Usage GetProperty <file_dir> <file_name> <session> <property>
  local in_file_dir="$1"
  local in_file_name="$2"
  local in_session="$3"
  local in_property="$4"
  local file_path="${in_file_dir}/${in_file_name}"
	if [[ ! -e ${file_path} ]] ; then
    echo ""
    return 1
  fi
  local line_value="$(grep -i ${in_session} ${file_path})"
  if [ "${line_value}" == "" ]; then
    echo ""
    return 1
  fi
  line_value="$(grep -i ${in_property} ${file_path})"
  if [ "${line_value}" == "" ]; then
    echo ""
    return 1
  fi
  local ret="${line_value#*=}"
  echo "${ret}"
}

ini::SetProperty()
{
  # Usage SetProperty <file_dir> <file_name> <session> <property> <value>
  local in_file_dir="$1"
  local in_file_name="$2"
  local in_session="$3"
  local in_property="$4"
  local in_value="$5"
  local file_path="${in_file_dir}/${in_file_name}"
	if [[ ! -e ${file_path} ]] ; then
    echo "[${in_session}]" > ${file_path}
    echo "${in_property}=${in_value}" >> ${file_path}
    echo "true"
    return 0
  fi
  local temp_file_path="${file_path}__temp"
  rm -f ${temp_file_path}
  local session=""
  local add="false"
  while IFS= read -r line; do
    if [ "${line:0:1}" == "[" ] ; then
      session="${line}"
    fi
    if [ "[${in_session}]" != "${session}" ]; then 
      echo "${line}" >> ${temp_file_path}
      continue
    fi
  done < ${file_path}
  mv "${temp_file_path}" "${file_path}"
  rm -f "${temp_file_path}"
  echo "false"
}
