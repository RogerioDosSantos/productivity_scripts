
source ./_qa.sh
source ./_devops.sh

devops_tests::StartJenkinsServer()
{
  devops::StartJenkinsServer | qa::AreEqual "true" "Could not start Jenkins server"
}

devops_tests::StartConanRepository()
{
  devops::StartConanRepository | qa::AreEqual "true" "Could not start Conan Repository server"
}

qa::Init "devops"

devops_tests::StartJenkinsServer
devops_tests::StartConanRepository

qa::End


