
source ./_profile.sh
source ./_log.sh
source ./_docker.sh

builder::image()
{
  if [ "$#" != 0 ]; then
    builder__image="$1"
    log::Log "info" "5" "Builder Image" "$1"
    return 0
  fi

  echo "${builder__image:-"$(profile::GetValue "builder_image" "rogersantos/builder_linux_x86:gcc_4_9")"}"
}

builder::container_name()
{
  if [ "$#" != 0 ]; then
    builder__container_name="$1"
    log::Log "info" "5" "Builder Container Name" "$1"
    return 0
  fi

  echo "${builder__container_name:-"$(profile::GetValue "builder_container_name" "builder_linux_x86")"}"
}

builder::workspace_volume()
{
  if [ "$#" != 0 ]; then
    builder__workspace_volume="$1"
    log::Log "info" "5" "Builder Workspace Directory" "$1"
    return 0
  fi

  echo "${builder__workspace_volume:-"$(profile::GetValue "builder_workspace_volume" "/c/Users/roger/git/roger/projects")"}"
}

builder::stage_volume()
{
  if [ "$#" != 0 ]; then
    builder__stage_volume="$1"
    log::Log "info" "5" "Builder Stage Directory" "$1"
    return 0
  fi

  echo "${builder__stage_volume:-"$(profile::GetValue "builder_stage_volume" "/c/Users/roger/git/roger/projects/stage")"}"
}

builder::StartBuilder()
{
  #Usage: StartBuilder

  # Properties
  local image="$(builder::image)"
  local container_name="$(builder::container_name)"
  local workspace_volume="$(builder::workspace_volume)"
  local stage_volume="$(builder::stage_volume)"

  log::Log "info" "5" "Starting Builder (${image})" ""

  if [ "$(docker::IsContainerRunning "${container_name}")" == "true" ]; then
    log::Log "info" "1" "Builder Client (${container_name}) container is already running" ""
    echo "true"
    return 0
  fi

  local proxy_config="$(docker::GetProxyConfiguration)"
  local docker_command="docker run --name ${container_name} --rm -d -it ${proxy_config} -v /var/run/docker.sock:/var/run/docker.sock -v ${workspace_volume}:/home/conan/workspace -v ${stage_volume}:/home/conan/.conan/data ${image} /bin/bash"
  log::Log "info" "1" "Docker Command" "${docker_command}"

  local result="$(${docker_command})"
  log::Log "info" "5" "Docker Command Result" "${result}"
  if [ "$(docker::IsContainerRunning "${container_name}")" == "true" ]; then
    log::Log "info" "5" "Builder started with success" ""
    echo "true"
    return 0
  fi

  echo "false"
}



