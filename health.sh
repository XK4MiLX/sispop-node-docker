#!/bin/bash

extract_time() {
  time_str=$1
  value=$(echo "$time_str" | grep -oE '([0-9]+(\.[0-9]+)?)\s*(min|sec)' | sed -E 's/([0-9]+(\.[0-9]+)?)\s*(min|sec)/\1 \3/')

  if [ -n "$value" ]; then
      numeric_part=$(echo "$value" | awk '{print $1}')
      unit=$(echo "$value" | awk '{print $2}')

      case $unit in
          "min")
              seconds=$(awk -v num="$numeric_part" 'BEGIN { printf "%.0f", num * 60 }')
              echo "${seconds}"
              ;;
          "sec")
              echo "${numeric_part}"
              ;;
      esac
  fi
}

status=$(sispopd status)
height=$(echo "$status" | grep -oP 'Height: \S+')
percentage=$(echo "$status" | grep -oP '(\d+\.\d+)%')
sn_part=$(echo "$status" | grep -oP 'SN: \K.*' | cut -d' ' -f2-)
output="$height ($percentage), $sn_part"
echo -e "$output"

if [[ $output == "" ]]; then
 exit 1
fi

IFS=, read -ra time_parts <<< "$output"
storage_time=$(extract_time "${time_parts[2]}")
sispopnet_time=$(extract_time "${time_parts[3]}")

if [[ "$sispopnet_time" != "" && "$storage_time" != "" ]]; then
  if [[ "$sispopnet_time" -ge 305 ]]; then
    echo -e "Performing your action because Sispopnet last ping time is greater than 305 seconds."
    supervisorctl restart sispopnet > /dev/null 2>&1
  else
    echo -e "Sispopnet last ping time is within acceptable range: $sispopnet_time seconds."
  fi

  if [[ "$storage_time" -ge 305 ]]; then
    echo "Performing your action because Storage last ping time is greater than 305 seconds."
    supervisorctl restart storage > /dev/null 2>&1
  else
    echo -e "Storage last ping time is within acceptable range: $storage_time seconds."
  fi
fi
