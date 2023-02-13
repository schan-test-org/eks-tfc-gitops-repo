MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=1996251c

--1996251c
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

cat /etc/docker/daemon.json | jq '. + {"insecure-registries": ["repo.svchub.connected-car.io:5000"]}' > daemon.json
mv daemon.json /etc/docker/daemon.json
systemctl daemon-reload && systemctl restart kubelet
--1996251c--

# configure docker insecure for private registry (daemon.json)
cat /etc/docker/daemon.json | jq '. + {"insecure-registries": ["DOMAIN:PORT"]}' > daemon.json
mv daemon.json /etc/docker/daemon.json

# configure auth for private registry (config.json)
mkdir -p ~/.docker
echo "{}" | jq '. + {"auths": {"kdocker.amaranth10.co.kr:5050": {"username":"USERID","password":"PASSWORD.","auth":"TOKEN"}}}' > config.json
mv config.json ~/.docker/config.json
