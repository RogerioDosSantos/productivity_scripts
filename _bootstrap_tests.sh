#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_bootstrap.sh

bootstrap_tests::BootstrapCpp()
{
  mkdir -p ./bootstrap_tests_temp_dir > /dev/null

  bootstrap::BootstrapCpp ./bootstrap_tests_temp_dir | grep directories | qa::AreEqual "bootstrap_files" "Bootstrap Changed"

  rm ./bootstrap_tests_temp_dir -r > /dev/null
}

bootstrap_tests::Bootstrap()
{
  mkdir -p ./bootstrap_tests_temp_dir > /dev/null

  bootstrap::Bootstrap "cpp" ./bootstrap_tests_temp_dir | grep directories | qa::AreEqual "bootstrap_files" "Bootstrap Changed"

  rm ./bootstrap_tests_temp_dir -r > /dev/null
}

qa::Init "bootstrap"

if [ "${1}" != "" ]; then
  bootstrap_tests::${1}
else
  bootstrap_tests::Bootstrap
  bootstrap_tests::BootstrapCpp
fi

qa::End

popd > /dev/null
