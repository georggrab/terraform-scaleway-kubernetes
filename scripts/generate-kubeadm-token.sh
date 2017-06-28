#!/bin/bash

TOKEN=$(head /dev/urandom | tr -dc a-z0-9 | head -c 23 | sed s/./\./7)

if [ -f ../terraform.tfvars ]; then
    PREFIX=../
fi

if [ -f ${PREFIX}terraform.tfvars ]; then
    export GENERATED_KUBEADM_TOKEN=$(echo -n $TOKEN | sed s/^/\"/ | sed s/$/\"/)
    envsubst < ${PREFIX}terraform.tfvars > ${PREFIX}terraform.tfvars_new
    mv ${PREFIX}terraform.tfvars_new ${PREFIX}terraform.tfvars
    echo "Substituted placeholder in terraform.tfvars with random token if it exists"
else
    echo $TOKEN
fi