#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_vim_helper.sh

vim_helper_tests::GetInput()
{
  ret=$(vim_helper::GetInput "Just press enter:" "enter_pressed") 
  echo "$ret" | qa::AreEqual "get_default_input" "Could not get default imput"
  ret=$(vim_helper::GetInput "Press a and enter" "invalid_value") 
  echo "$ret" | qa::AreEqual "get_input_a" "Could not get imput"
}

qa::Init "vim_helper"

if [ "${1}" != "" ]; then
  vim_helper_tests::${1}
else
  vim_helper_tests::GetInput
fi

qa::End

popd > /dev/null
