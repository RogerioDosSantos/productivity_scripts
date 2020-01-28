#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_ini_files.sh

ini_tests::SetProperty()
{
  mkdir -p ./ini_tests_temp_dir > /dev/null
  cd ./ini_tests_temp_dir
  local dir_name="$(pwd)"
  cd ..

  ini::SetProperty "${dir_name}" "test_01.ini" "Session_01" "Property_01" "Value_01" | qa::AreEqual "is_true" 
  cat "${dir_name}/test_01.ini" | qa::AreEqual "ini_set_property" "test_01_no_file"
  ini::SetProperty "${dir_name}" "test_01.ini" "Session_01" "Property_01" "Value_01" #| qa::AreEqual "is_true" 
  cat "${dir_name}/test_01.ini" #| qa::AreEqual "ini_set_property" "test_01_no_file"

  # rm ./ini_tests_temp_dir -r > /dev/null
}

qa::Init "ini"

if [ "${1}" != "" ]; then
  ini_tests::${1}
else
  ini_tests::SetProperty
fi

qa::End

popd > /dev/null
