#!/bin/bash
if [[ ! -d /root/.sispopnet ]]; then
  echo -e "Initial setup.."
  mkdir /root/.sispopnet
  cp /sispopnet.ini /root/.sispopnet/sispopnet.ini
  wget https://seed.sispop.site/bootstrap.signed
fi
echo -e "Awaiting.."
sleep 240
echo -e "Starting sispopnet.."
echo -e "----------------------------------------------------------------------------------------------------"
sispopnet
