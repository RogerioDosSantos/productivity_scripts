#!/bin/bash

config_question="$1"
config_file="$2"

read -p "${config_question} " user_answer
echo "${user_answer}" > ${config_file}

# Wait for the file to be created on the disk
echo "Waiting for the file creation"
file_time_out=0
while [ "$file_time_out" -lt 100 -a ! -e ${config_file} ]; do
        file_time_out=$((file_time_out+1))
        sleep .1
done
