
source ./_qa.sh
source ./_profile.sh

profile_tests::GetValue()
{
  profile::GetValue "log_level" 5  | qa::AreEqual "log_level_default" "Could not get the default profile when the file does not exist"
  profile::GetValue "log_level" 6  | qa::AreEqual "log_level_default" "Could not get the value from the profile file (Default value not added)"
  profile::GetValue "log_enabled" false | qa::AreEqual "log_enabled" "Could not get the default value from the profile file when file exist"
  profile::GetValue "log_enabled" true | qa::AreEqual "log_enabled" "Could not get the value from the profile file (Default value not added)"
}

qa::Init "profile"

profile_tests::GetValue

qa::End


