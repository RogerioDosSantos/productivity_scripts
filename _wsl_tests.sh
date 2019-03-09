#/usr/bin/env bash

pushd "$(dirname "$0")" > /dev/null

source ./_qa.sh
source ./_log.sh
source ./_wsl.sh

wsl_tests::ConvertLinuxPathToWindowsPath()
{
  wsl::ConvertLinuxPathToWindowsPath "/C/Program Files (x86)/Common Files" | qa::AreEqual "program_files_common" "Could not convert Linux Path"
  wsl::ConvertLinuxPathToWindowsPath "/mnt/C/Program Files (x86)/Common Files" | qa::AreEqual "program_files_common" "Could not convert Linux Path"
  wsl::ConvertLinuxPathToWindowsPath "/c/Windows/System32" | qa::AreEqual "system_32" "Could not convert Linux Path"
  wsl::ConvertLinuxPathToWindowsPath "/mnt/c/Windows/System32" | qa::AreEqual "system_32" "Could not convert Linux Path"
}

# log::show_log "true"
# log::level "5"
qa::Init "builder"

if [ "${1}" != "" ]; then
  wsl_tests::${1}
else
  wsl_tests::ConvertLinuxPathToWindowsPath
fi

qa::End
# log::End

popd > /dev/null
