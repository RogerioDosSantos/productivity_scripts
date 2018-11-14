
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

qa::Init "devops"

devops_tests::StartJenkinsServer
devops_tests::StartArtifactoryServer
devops_tests::StartBuilder

qa::End


