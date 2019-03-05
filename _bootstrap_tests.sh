#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_bootstrap.sh

bootstrap_tests::BootstrapCpp()
{
  mkdir -p ./bootstrap_tests_temp_dir
  bootstrap::BootstrapCpp ./bootstrap_tests_temp_dir #| qa::AreEqual "program_settings_path" "Could not convert Linux Path"
  tree ./bootstrap_tests_temp_dir
  rm ./bootstrap_tests_temp_dir -r 
}

qa::Init "builder"

if [ "${1}" != "" ]; then
  bootstrap_tests::${1}
else
  bootstrap_tests::BootstrapCpp
fi

qa::End

popd > /dev/null
