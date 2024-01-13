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
uptime=$(echo "$status" | grep -oP 'uptime \K[0-9]+d [0-9]+h [0-9]+m [0-9]+s')
output="$height ($percentage), $sn_part"

if [[ $output == "" ]]; then
 echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I --------------------------------------------------"
 echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I ERROR: Unable to parse sispopd status"  
 echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I --------------------------------------------------" >> /proc/1/fd/1
 echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I ERROR: Unable to parse sispopd status"   >> /proc/1/fd/1
 exit 1
fi

echo -e "$output, uptime: $uptime"
echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I --------------------------------------------------" >> /proc/1/fd/1
echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I $output"  >> /proc/1/fd/1

IFS=, read -ra time_parts <<< "$output"
storage_time=$(extract_time "${time_parts[2]}")
sispopnet_time=$(extract_time "${time_parts[3]}")

if [[ "$sispopnet_time" != "" && "$storage_time" != "" ]]; then
  if [[ "$sispopnet_time" -ge 305 ]]; then
    echo -e "Performing your action because Sispopnet last ping time is greater than 305 seconds."
    echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I Performing your action because Sispopnet last ping time is greater than 305 seconds." >> /proc/1/fd/1
    supervisorctl restart sispopnet > /dev/null 2>&1
  else
    echo -e "Sispopnet last ping time is within acceptable range: $sispopnet_time seconds."
    echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I Sispopnet last ping time is within acceptable range: $sispopnet_time seconds." >> /proc/1/fd/1
  fi

  if [[ "$storage_time" -ge 305 ]]; then
    echo "Performing your action because Storage last ping time is greater than 305 seconds."
    echo "$(date '+%Y-%m-%d %H:%M:%S.%3N') I Performing your action because Storage last ping time is greater than 305 seconds." >> /proc/1/fd/1
    supervisorctl restart storage > /dev/null 2>&1
  else
    echo -e "Storage last ping time is within acceptable range: $storage_time seconds."
    echo -e "$(date '+%Y-%m-%d %H:%M:%S.%3N') I Storage last ping time is within acceptable range: $storage_time seconds."  >> /proc/1/fd/1
  fi
fi
