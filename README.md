# Sispop-node docker

## Minimum Hardware Requirements:
- 1vCPU
- 1GB Ram
- 8GB SSD
  

## Run Docker
```sh
mkdir /home/$USER/sispop-node
```

```sh
docker run -d -p 22020:22020 -p 22021:22021 -p 20000:20000 -p 50000:50000 -p 1090:1090/udp --device=/dev/net/tun --cap-add=NET_ADMIN --restart=always -v /home/$USER/sispop-node:/root --name 'fluxsispop-node' xk4milx/sispop-node-docker
```

## Logs
```sh
2024-01-13 10:25:48.426 I Height: 94962/94962 (100.0%), not registered, last pings: 66sec (storage), 1.5min (sispopnet)
2024-01-13 10:25:48.478 I Sispopnet last ping time is within acceptable range: 90 seconds.
2024-01-13 10:25:48.479 I Storage last ping time is within acceptable range: 66 seconds.
```
## Notice
Acceptable range of ping is 305 milliseconds after that, the component is restarted.
