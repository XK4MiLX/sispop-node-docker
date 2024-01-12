#!/bin/bash
status=$(sispopd status)
height=$(echo "$status" | grep -oP 'Height: \S+')
# Extract the percentage from the 'status' variable
percentage=$(echo "$status" | grep -oP '(\d+\.\d+)%')
# Extract the part after "SN:" from the 'status' variable
sn_part=$(echo "$status" | grep -oP 'SN: \K.*' | cut -d' ' -f2-)
output="$height ($percentage), $sn_part"
echo -e "$output"
if [[ $output == "" ]]; then
 exit 1
fi
