#!/bin/bash
echo -e "Initial awaiting.."
sleep 120
echo -e "Starting storage.."
echo -e "----------------------------------------------------------------------------------------------------"
sispop-storage 0.0.0.0 22020 --data-dir=/root/.sispop/storage --sispopd-rpc-port=30000
