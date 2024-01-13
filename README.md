# Sispop-node docker
- RUN DOCKER LOCALY
  ```js
docker run -d -p 22020:22020 -p 22021:22021 -p 20000:20000 -p 50000:50000 -p 1090:1090/udp --device=/dev/net/tun --cap-add=NET_ADMIN --restart=always -v /home/$USER/sis-place:/root --name "sispop-node" xk4milx/sispop-node
```
