
# Disable mingw and msys path expansion (https://github.com/docker/toolbox/issues/282)
export MSYS_NO_PATHCONV=1

docker::BuildImage()
{
  # Usage <image_name> <docker_file_dir>
  local in_image_name=$1
  local in_docker_file_dir=$2

  docker build -t "${in_image_name}" "${in_docker_file_dir}"
}

docker::IsVirtualBox()
{
  # Usage: IsVirtualBox

  local is_virtualbox_provider="$(docker info | grep provider=virtualbox)"
  if [[ ${is_virtualbox_provider} = *"provider=virtualbox"* ]]; then
    echo "true"
    return 0
  fi

  echo "false"
}

docker::NormalizeDir()
{
  # Usage: NormalizeDir <in:directory> 
  local directory=$1

  #TODO(Roger) - Put platform and if docker is running on Ubuntu as parameter to make thin function testable
  local is_ubuntu_on_windows=$([ -e /proc/version ] && grep -l Microsoft /proc/version || echo "")
  local is_cygwin=$([ -e /proc/version ] && grep -l MINGW /proc/version || echo "")
  if [ -n "${is_ubuntu_on_windows}" ]; then
    log::Log "info" "5" "Script is being called from Ubuntu on Windows" ""
    if "$(docker::IsVirtualBox)" == "true"; then
      log::Log "info" "5" "Docker Server is running on VirtualBox" ""
      directory=${directory/\/mnt\//}
      directory="/${directory}"
      echo "${directory}"
      return 0
    fi

    log::Log "info" "5" "Docker Server is running natively" ""
    directory=${directory/\/mnt\//}
    directory=${directory/\//:\/}
    echo "${directory}"
    return 0
  fi

  if [ -n "${is_cygwin}" ]; then
      log::Log "info" "5" "Docker Server is running on VirtualBox" ""
      directory=${directory/\//}
      directory=${directory/\//:\/}
      echo "${directory}"
      return 0
  fi

  echo "${directory}"
}

docker::IsContainerRunning()
{
  # Usage: IsContainerRunning <in:container_name>
  local in_container_name=$1
  local running_container="$(docker ps --format '{{.Names}}' | grep ${in_container_name})"
  log::Log "info" "5" "Running container" "${running_container}"
  if [ "${running_container}" == "${in_container_name}" ]; then
    echo "true"
    return 0
  fi

  echo "false"
}

docker::GetProxyConfiguration()
{
  # Usage: GetProxyConfiguration

  local proxy_config=""
  local current_config="$(printenv http_proxy)"
  if [ "${current_config}" != "" ]; then
    proxy_config="--env http_proxy=${current_config}"
  fi

  current_config="$(printenv https_proxy)"
  if [ "${current_config}" != "" ]; then
    proxy_config="${proxy_config} --env https_proxy=${current_config}"
  fi

  current_config="$(printenv ftp_proxy)"
  if [ "${current_config}" != "" ]; then
    proxy_config="${proxy_config} --env ftp_proxy=${current_config}"
  fi

  current_config="$(printenv no_proxy)"
  if [ "${current_config}" != "" ]; then
    proxy_config="${proxy_config} --env no_proxy=${current_config}"
  fi

  echo "${proxy_config}"
  return 0
}

