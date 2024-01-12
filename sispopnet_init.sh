#!/bin/bash
if [[ ! -d /root/.sispopnet ]]; then
  echo -e "Initial setup.."
  mkdir /root/.sispopnet
  cp /sispopnet.ini /root/.sispopnet/sispopnet.ini
  cd /root/.sispopnet
  wget https://seed.sispop.site/bootstrap.signed
  if [[ ! /root/.sispopnet/self.signed ]]; then
    cp bootstrap.signed self.signed
  fi
fi
if [[ "$1" != "bypass" ]]; then
  echo -e "Awaiting.."
  sleep 180
fi
echo -e "Starting sispopnet.."
echo -e "----------------------------------------------------------------------------------------------------"
sispopnet
