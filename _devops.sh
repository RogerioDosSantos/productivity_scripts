
source ./_log.sh
source ./_docker.sh
source ./_wsl.sh
source ./_builder.sh

devops::SetupScripts()
{
  # Usage: SetupScripts

  local current_dir=$(pwd -P)
  mkdir -p ~/bin
  if [ ! -f ~/bin/devops  ]; then
    echo -ne "Creating devops ... "
    echo '#!/usr/bin/env bash' >> ~/bin/devops
    echo "${current_dir}/devops.sh \"\$@\"" >> ~/bin/devops
    chmod +x ~/bin/devops
    echo "DONE"
  fi
}

devops::SetupWSL()
{
  # Usage: SetupWSL

  local ui_yes_no
	while true; do
    read -p "Would you like to install/update programs (yes(y)/no(n))? " ui_yes_no
    case $ui_yes_no in
        [Yy]* ) wsl::InstallPrograms; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
	done

	while true; do
    read -p "Would you like to create/update links (yes(y)/no(n))? " ui_yes_no
    case $ui_yes_no in
        [Yy]* ) wsl::PrepareLinks; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
	done
}

devops::StartJenkinsServer()
{
  #Usage: StartJenkinsServer

  log::Log "info" "5" "Starting Jenkins Server" ""

  if [ "$(docker::IsContainerRunning "jenkins")" == "true" ]; then
    log::Log "info" "5" "Jenkins container is already running" ""
    echo "true"
    return 0
  fi

  local proxy_config="$(docker::GetProxyConfiguration)"
  local docker_command="docker run --name jenkins --rm -d ${proxy_config} -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users:/var/jenkins_home/host -p 8080:8080 -p 50000:50000 -v jenkins_data:/var/jenkins_home rogersantos/jenkins_server"
  log::Log "info" "5" "Docker Command" "${docker_command}"

  local result="$(${docker_command})"
  log::Log "info" "5" "Docker Command Result" "${result}"
  if [ "$(docker::IsContainerRunning "jenkins")" == "true" ]; then
    log::Log "info" "5" "Jenkins Server started with success" ""
    echo "true"
    return 0
  fi

  echo "false"
}

devops::StartJenkinsServerCommand()
{
  #Usage: StartJenkinsServerCommand

  echo "Starting Jenkins Server..."
  local result="$(devops::StartJenkinsServer)"
  if [ "${result}" != "true" ]; then
    echo "- Could not start Jenkins Server!"
    return 0
  fi

  echo "Jenkins Server Url: http://localhost:8080"
  echo "Jenkins Server Data Volume: jerkins_data"

  local initial_password="$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)"
  echo "Jenkins Server Initial Password: ${initial_password}"
}

devops::StartArtifactoryServer()
{
  #Usage: StartArtifactoryServer

  log::Log "info" "5" "Conan Package Manager Repository (JFrog Artifactory Server)" ""

  local running_container="$(docker ps --format '{{.Names}}' | grep conan_repository)"
  if [ "$(docker::IsContainerRunning "conan_repository")" == "true" ]; then
    log::Log "info" "5" "Conan Package Manager Repository container is already running." ""
    echo "true"
    return 0
  fi

  # Note: Port 8081 is used by the Mc'Affee anti-virus for this reazon I am setting it to the port 8082
  local port_config="-p 8082:8081"
  local proxy_config="$(docker::GetProxyConfiguration)"
  local name_config="--name conan_repository"
  local data_config="-v conan_repository_data:/var/opt/jfrog/artifactory"
  local image_config="docker.bintray.io/jfrog/artifactory-cpp-ce:latest"
  local docker_command="docker run --rm -d ${name_config} ${proxy_config} ${data_config} ${port_config} ${image_config}"
  log::Log "info" "5" "Docker Command" "${docker_command}"

  local result="$(${docker_command})"
  log::Log "info" "5" "Docker Command Result" "${result}"
  if [ "$(docker::IsContainerRunning "conan_repository")" == "true" ]; then
    log::Log "info" "5" "Conan Package Manager Repository started with success" ""
    echo "true"
    return 0
  fi

  echo "false"
}

devops::StartArtifactoryServerCommand()
{
  #Usage: StartArtifactoryServerCommand

  echo "Conan Package Manager Repository (JFrog Artifactory Server)..."
  local result="$(devops::StartArtifactoryServer)"
  if [ "${result}" != "true" ]; then
    echo "- Could not start Conan Package Manager Repository (JFrog Artifactory Server)!"
    return 0
  fi

  echo "Conan Package Manager Repository Server Url: http://localhost:8082"
}

devops::StartBuilder()
{
  #Usage: StartBuilder

  echo "Starting builder with the following configutation:"
  echo "- Image: $(builder::image)"
  echo "- Container name: $(builder::container_name)"
  echo "- Workspace: $(builder::workspace_volume)"
  echo "- Stage: $(builder::stage_volume)"

  local result="$(builder::StartBuilder)"
  if [ "${result}" != "true" ]; then
    echo "- Could not start Builder!"
    return 0
  fi

  echo "Builder started"
}

devops::StartFnServer()
{
  # Usage: StartFnServer

  local name="fnserver"
  local docker_socket="-v /var/run/docker.sock:/var/run/docker.sock"
  local port="--privileged -p 8080:8080"
  local proxy="$(docker::GetProxyConfiguration)"
  local data="-v fn_server_data:/app/data"
  local entrypoint="--entrypoint ./fnserver"
  local image="fnproject/fnserver"
  local docker_command="docker run --rm -d -i --name ${name} ${docker_socket} ${proxy} ${data} ${port} ${entrypoint} ${image}"
  log::Log "info" "5" "Docker Command" "${docker_command}"
  local result="$(${docker_command})"
  log::Log "info" "5" "Docker Command Result" "${result}"
  if [ "$(docker::IsContainerRunning "${name}")" == "true" ]; then
    log::Log "info" "5" "Fn Server started with success" ""
    echo "true"
    return 0
  fi

  return "false"
}

devops::StartFnServerCommand()
{
  #Usage: StartFnServerCommand

  echo "Starting Fn Server..."
  local result="$(devops::StartFnServer)"
  if [ "${result}" != "true" ]; then
    echo "- Could not start Fn Server!"
    return 0
  fi

  echo "Fn Server Url: http://localhost:8080"
}

devops::GetDockerRunCommand()
{
  #Usage: GetDockerRunCommand <in:container>
  local container="$1"

  local docker_command="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock rogersantos/docker_runlike ${container}"
  log::Log "info" "5" "Docker Command" "${docker_command}"
  echo "$(${docker_command})"
}

devops::ExecuteOnWindows()
{
  wsl::Execute "$@"
}

devops::ConvertToWindowsPath()
{
  wsl::ConvertLinuxPathToWindowsPath "$@"
}
