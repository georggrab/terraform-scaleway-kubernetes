#!/bin/sh

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

export DOCKER_OPTS="-s overlay"

apt-get update

apt-get install dmsetup -y
dmsetup mknodes

# Install docker if you don't have it already.
apt-get install -y docker-engine

# Weird Ubuntu 16.04 Fix for Docker Installation
mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF >/etc/systemd/system/docker.service.d/overlay.conf
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// -s overlay
EOF

apt-get install -y kubelet kubeadm kubernetes-cni