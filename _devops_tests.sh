
source ./_qa.sh
source ./_devops.sh

devops_tests::StartJenkinsServer()
{
  devops::StartJenkinsServer | qa::AreEqual "true" "Could not start Jenkins server"
}

devops_tests::StartArtifactoryServer()
{
  devops::StartArtifactoryServer | qa::AreEqual "true" "Could not start Conan Repository server"
}

devops_tests::StartBuilder()
{
  devops::StartBuilder | grep "Builder started" | qa::AreEqual "builder_started" "Could not start builder"
}

devops_tests::GetDockerRunCommand()
{
  docker run --rm -it -d --name "alpine_docket_run_command_test" alpine:3.8 /bin/sh 
  local ret="$(devops::GetDockerRunCommand "alpine_docket_run_command_test")"
  echo "${ret}" | cut -d'-' -f1 | qa::AreEqual "docker_command" "Could not get docker command"
  echo "${ret}" | cut -d'-' -f3 | qa::AreEqual "alpine_container_name" "Could not get container name"
  echo "${ret}" | cut -d'-' -f7 | qa::AreEqual "alpine_environment" "Could not get environment"
  echo "${ret}" | cut -d'-' -f9 | qa::AreEqual "alpine_restart" "Could not get restart mode"
  echo "${ret}" | cut -d'-' -f11 | qa::AreEqual "alpine_detach" "Could not get detach mode"
  echo "${ret}" | cut -d'-' -f12 | qa::AreEqual "alpine_tag" "Could not get tag"
  docker stop "alpine_docket_run_command_test"
}

qa::Init "devops"

devops_tests::StartJenkinsServer
devops_tests::StartArtifactoryServer
devops_tests::StartBuilder
devops_tests::GetDockerRunCommand

qa::End


