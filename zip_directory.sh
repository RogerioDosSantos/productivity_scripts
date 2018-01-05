#!/bin/bash

# Configuration
echo "* $(basename "$0")"
echo "- Configuration:"
config_source="$1"
echo "1- config_source: ${config_source}"
config_destination="$2"
echo "2- config_destination: ${config_destination}"

# Setup - Go to the directory where the bash file is
call_dir=$(pwd)
cd "$(dirname "$0")"
bash_dir=$(pwd)
echo "- Called from ${call_dir}"
echo "- Running from ${bash_dir}"
cd "$(dirname "$0")"

# Exit on any non-zero status.
trap 'exit' ERR
set -E

# Instructions
cd "${config_source}"
dir_name=${PWD##*/}
if [[ -z "${config_destination}" ]]; then
  config_destination="${call_dir}/${dir_name}.zip"
fi

echo "- Compressing folder ${config_source} to ${config_destination}"
zip -r9 "${config_destination}" *
echo "- File Created: ${config_destination}"

# Setup - Return to the called directory
cd "${call_dir}"

