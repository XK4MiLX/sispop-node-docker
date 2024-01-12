#!/bin/bash
if [[ ! -d /root/.sispopnet ]]; then
  mkdir /root/.sispopnet
  cp /sispopnet.ini /root/.sispopnet/sispopnet.ini
  wget https://seed.sispop.site/bootstrap.signed
fi
sleep 240
sispopnet
