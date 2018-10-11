
source ./_qa.sh
source ./_devops.sh

devops_tests::StartJenkinsServer()
{
  devops::StartJenkinsServer | qa::AreEqual "true" "Could not start Jenkins server"
}

qa::Init "devops"

devops_tests::StartJenkinsServer

qa::End


