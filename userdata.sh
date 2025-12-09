#!/bin/bash

apt-get update -y
apt-get install -y docker.io

usermod -aG docker ubuntu

mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
EOF

sed -i 's#ExecStart=.*#ExecStart=/usr/bin/dockerd#' /lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker

systemctl enable docker
