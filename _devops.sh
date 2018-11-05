
source ./_log.sh
source ./_docker.sh
source ./_wsl.sh

devops::SetupScripts()
{
  # Usage: SetupScripts

  mkdir -p ~/bin
  if [ ! -f ~/bin/devops  ]; then 
    echo "Creating devops" 
    echo '#!/usr/bin/env bash' >> ~/bin/devops
    echo '/mnt/c/Users/roger/git/roger/productivity/scripts/devops.sh "$@"' >> ~/bin/devops
    chmod +x ~/bin/devops
  fi
}

devops::SetupWSL()
{
  # Usage: SetupWSL

  wsl::PrepareDocker
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
  local docker_command="docker run --name jenkins --rm -d ${proxy_config} -p 8080:8080 -p 50000:50000 -v jenkins_data:/var/jenkins_home jenkins/jenkins:lts"
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

devops::StartConanRepository()
{
  #Usage: StartConanRepository

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

devops::StartConanRepositoryCommand()
{
  #Usage: StartConanRepositoryCommand

  echo "Conan Package Manager Repository (JFrog Artifactory Server)..."
  local result="$(devops::StartConanRepository)"
  if [ "${result}" != "true" ]; then
    echo "- Could not start Conan Package Manager Repository (JFrog Artifactory Server)!"
    return 0
  fi

  echo "Conan Package Manager Repository Server Url: http://localhost:8082"
}


