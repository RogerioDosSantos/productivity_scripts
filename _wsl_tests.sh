#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_wsl.sh

wsl_tests::ConvertLinuxPathToWindowsPath()
{
  wsl::ConvertLinuxPathToWindowsPath "/mnt/c/Users/roger.santos/work/PRODUCT/DEV/Builds/NT/OEM/Program Settings.ini" | qa::AreEqual "program_settings_path" "Could not convert Linux Path"
  wsl::ConvertLinuxPathToWindowsPath "/c/Users/roger.santos/work/PRODUCT/DEV/Builds/NT/OEM/Program Settings.ini" | qa::AreEqual "program_settings_path" "Could not convert Linux Path"
}

qa::Init "builder"

if [ "${1}" != "" ]; then
  wsl_tests::${1}
else
  wsl_tests::ConvertLinuxPathToWindowsPath
fi

qa::End

popd > /dev/null
