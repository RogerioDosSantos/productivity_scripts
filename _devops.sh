
source ./_log.sh
source ./_docker.sh

devops::StartJenkinsServer()
{
  #Usage: StartJenkinsServer

  log::Log "info" "5" "Starting Jenkins Server" ""

  local running_container="$(docker ps --format '{{.Names}}' | grep jenkins)"
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

  echo ""
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
