# Sispop-node docker

## Minimum Hardware Requirements:
- 1vCPU
- 1GB Ram
- 8GB SSD

## Install Docker
```sh
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install  -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
## Run Docker
- Create directory for bind mount
```sh
mkdir /home/$USER/sispop-node
```
- Run continer
```sh
docker run -d -p 22020:22020 -p 22021:22021 -p 20000:20000 -p 50000:50000 -p 1090:1090/udp --device=/dev/net/tun --cap-add=NET_ADMIN --restart=always -v /home/$USER/sispop-node:/root --name 'sispop-node' xk4milx/sispop-node-docker
```

## Node Status
```sh
docker logs sispop-node --tail 3
2024-01-13 10:25:48.426 I Height: 94962/94962 (100.0%), not registered, last pings: 66sec (storage), 1.5min (sispopnet)
2024-01-13 10:25:48.478 I Sispopnet last ping time is within acceptable range: 90 seconds.
2024-01-13 10:25:48.479 I Storage last ping time is within acceptable range: 66 seconds.
```
## Prepare Registration
```sh
docker exec -it sispop-node sispopd prepare_registration
```
```sh
2024-01-13 18:10:37.118 I Sispop 'Sweet Water' (v10.0.3-8d194d71d)
2024-01-13 18:10:37.126 I Generating SSL certificate
Current staking requirement: 150000.000000000 sispop
Will the operator contribute the entire stake? (Y/Yes/N/No/C/Cancel): Y

Enter the sispop address for the solo staker (B/Back/C/Cancel): 46pFUxroeo6XpQNCZCnoMmjAJorP6WL5tg4fetXXMdCZYXbuPSpot1kPt2DzRD4zHQ6LwFVLYRyRsNfm3uDasxUQT6BbFq3
Summary:
Operating costs as % of reward: 100%
Contributor     Address  Contribution       Contribution(%)
___________     _______  ____________       _______________
Operator        46pFUx   150000.000000000   100.000000000

Because the actual requirement will depend on the time that you register, the
amounts shown here are used as a guide only, and the percentages will remain
the same.

Do you confirm the information above is correct? (Y/Yes/N/No/B/Back/C/Cancel): Y
Run this command in the wallet that will fund this registration:

register_service_node 18446744073709551612 46pFUxroeo6XpQN3rnoMmjAJorP6WL5tgoiytXXMdCZYXbuPSpot1kPt2DzGD4zHQ6LwFVLYRyRsNfm3uDasxUQT6BbFq3 18446766073709551612 1704479112 3fcea4a26e695ad8243e45f92fda775bcfae0eded2270bb13a120ae7f85b748c bd55dc43ea5d26821855cbf75876e4b2cdcaca6r35f1798a141c81bc4cf25040d860a77cb115e0f8e01c61dba22703a0975e86bd847fd2f6720fa4fd709a2a903

This registration expires at 2024-01-27 06:11:52 PM UTC.
This should be in about 2 weeks, if it isn't, check this computer's clock.
Please submit your registration into the blockchain before this time or it will be invalid.
```
## Notice
Acceptable range of ping is 305 milliseconds after that the component is restarted.
It can be changed by custom value using: <br>
``-e PING_LIMIT=400``
