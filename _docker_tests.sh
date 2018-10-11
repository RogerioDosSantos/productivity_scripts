
source ./_qa.sh
source ./_docker.sh

docker_tests::IsContainerRunning()
{
  docker::IsContainerRunning "unexisting_container_name" | qa::AreEqual "not_running" "Reported that unexisting container is running"

  docker run --name is_container_running_test -d -t --rm alpine
  docker::IsContainerRunning "is_container_running_test" | qa::AreEqual "running" "Reported that existing container is not running"

  docker stop is_container_running_test
  docker::IsContainerRunning "is_container_running_test" | qa::AreEqual "not_running" "Reported that stopped container is running"
}

docker_tests::GetProxyConfiguration()
{
  http_proxy="http://http_proxy.com:8080"
  https_proxy="http://https_proxy.com:8080"
  ftp_proxy="http://ftp_proxy.com:8080"
  no_proxy="http://no_proxy.com:8080"
  docker::GetProxyConfiguration | qa::AreEqual "all" "Could not get the proxy configuration properly"

  http_proxy=""
  https_proxy=""
  ftp_proxy=""
  no_proxy=""
  docker::GetProxyConfiguration | qa::AreEqual "none" "Could not get the proxy configuration properly"
}

qa::Init "docker"

docker_tests::IsContainerRunning
docker_tests::GetProxyConfiguration

qa::End


