#!/bin/bash
if [[ "$1" != "bypass" ]]; then
  echo -e "Awaiting.."
  sleep 120
fi
echo -e "Starting storage.."
echo -e "----------------------------------------------------------------------------------------------------"
sispop-storage 0.0.0.0 22020 --data-dir=/root/.sispop/storage --sispopd-rpc-port=30000
