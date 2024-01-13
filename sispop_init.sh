#!/bin/bash
url_array=(
    "https://api4.my-ip.io/ip"
    "https://checkip.amazonaws.com"
    "https://api.ipify.org"
)

function get_ip() {
    for url in "$@"; do
        WANIP=$(curl --silent -m 15 "$url" | tr -dc '[:alnum:].')
        # Remove dots from the IP address
        IP_NO_DOTS=$(echo "$WANIP" | tr -d '.')
        # Check if the result is a valid number
        if [[ "$IP_NO_DOTS" != "" && "$IP_NO_DOTS" =~ ^[0-9]+$ ]]; then
            break
        fi
    done
}

get_ip "${url_array[@]}"
sleep 10
echo -e "Starting daemon.."
echo -e "CMD: sispopd --service-node --service-node-public-ip ${WANIP} --storage-server-port 22020 --seed-node 13.53.97.58"
echo -e "-----------------------------------------------------------------------------------------------------------------------"
sispopd --service-node --service-node-public-ip ${WANIP} --storage-server-port 22020 --seed-node 13.53.97.58
