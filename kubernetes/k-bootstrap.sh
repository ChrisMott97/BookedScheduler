#!/bin/bash

# Env variable defaults

: "${PUBLIC_SSH_KEY_PATH:=/home/$USER/.ssh/id_rsa.pub}"
: "${PRIVATE_SSH_KEY_PATH:=/home/$USER/.ssh/id_rsa}"

master="master"
nodes=("node1" "node2")
context="k3s"

# $1 = name
# $2 = disk
# $3 = memory
createInstance () {
  multipass launch -n "$1" -d "$2" -m "$3" --cloud-init - <<EOF
users:
- name: ${USER}
  groups: sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
  ssh_authorized_keys:
  - $(cat "${PUBLIC_SSH_KEY_PATH}")
EOF
}

getNodeIP() {
  echo $(multipass list | grep $1 | awk '{print $3}')
}

installK3sMasterNode() {
  MASTER_IP=$(getNodeIP $1)
  k3sup install --ip "$MASTER_IP" --context "$context" --k3s-channel stable --local-path ~/.kube/config --user "$USER" --ssh-key "${PRIVATE_SSH_KEY_PATH}"
}

installK3sWorkerNode() {
  NODE_IP=$(getNodeIP $1)
  k3sup join --server-ip "$MASTER_IP" --ip "$NODE_IP" --user "$USER" --ssh-key "${PRIVATE_SSH_KEY_PATH}"
}

echo Creating master instance...
createInstance "$master" 5G 1G

echo Creating node instances...
for node in "${nodes[@]}"
do
 createInstance "$node" 5G 1G
done

echo Installing K3S on master node...
installK3sMasterNode "$master"

echo Installing K3S on worker nodes...
for node in "${nodes[@]}"
do
 installK3sWorkerNode "$node"
done

echo Installing MariaDB...
helm install mariadb --set auth.rootPassword=example,auth.database=bookedscheduler,auth.username=booked_user,auth.password=password bitnami/mariadb 

echo Orchestrating deployments...
kubectl create deployment booked --image=cmott97/booked:latest
kubectl expose deployment booked --type="NodePort" --port 80
echo Booked accessible at $(getNodeIP "$master"):$(kubectl get service booked -o yaml | grep 'nodePort' | awk '{print $3}')
