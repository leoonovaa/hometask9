#!/bin/bash

# --- UPDATE SYSTEM ---
apt-get update -y
apt-get install -y docker.io

# --- ADD USER ubuntu TO docker GROUP ---
usermod -aG docker ubuntu

# --- CREATE /etc/docker/daemon.json ---
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
EOF

# --- FIX systemd docker.service ---
sed -i 's#ExecStart=.*#ExecStart=/usr/bin/dockerd#' /lib/systemd/system/docker.service

# --- RELOAD SYSTEMD + RESTART DOCKER ---
systemctl daemon-reload
systemctl restart docker

# --- ENABLE DOCKER ON BOOT ---
systemctl enable docker