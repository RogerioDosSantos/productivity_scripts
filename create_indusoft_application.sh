#!/bin/bash

# Configuration
echo "* $(basename "$0")"
echo "- Configuration:"

config_template_name="$1"
echo "  1- config_template_name: ${config_template_name}"

if [ "${config_template_name}" = "" ]; then
  echo "Error: Invalid Configuration" 
  exit
fi

config_destination_dir="$2"
echo "2- config_destination_dir: ${config_destination_dir}"

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
cd "${call_dir}"
dir_name=${PWD##*/}
if [[ -z "${config_destination_dir}" ]]; then
  timestamp=$(date '+%Y%m%d_%H%M%S')
  config_destination_dir="${call_dir}/application/${config_template_name}_${timestamp}"
fi

template_dir="${HOME}/roger/productivity/templates/indusoft/${config_template_name}"
echo "- Copying folder ${template_dir} to ${config_destination_dir}"
mkdir -p ${config_destination_dir}
cp -r ${template_dir}/* ${config_destination_dir}/

echo "- InduSoft Application created at ${config_destination_dir}"
# Setup - Return to the called directory
cd "${call_dir}"

