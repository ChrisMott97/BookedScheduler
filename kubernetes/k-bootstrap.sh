#!/bin/bash

# Env variable defaults

: "${PUBLIC_SSH_KEY_PATH:=/home/$USER/.ssh/id_rsa.pub}"
: "${PRIVATE_SSH_KEY_PATH:=/home/$USER/.ssh/id_rsa}"

master="master"
nodes=("node1" "node2" "node3")
context="k3s"

# $1 = name
# $2 = disk
# $3 = memory
# $4 = cpu
# $5 = image
createInstance () {
  multipass launch -n "$1" -d "$2" -m "$3" -c "$4" --cloud-init - <<EOF
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
createInstance "$master" 5G 1G 1

echo Creating node instances...
for node in "${nodes[@]}"
do
 createInstance "$node" 5G 2G 1
done

echo Installing K3S on master node...
installK3sMasterNode "$master"

echo Installing K3S on worker nodes...
for node in "${nodes[@]}"
do
 installK3sWorkerNode "$node"
done

echo Installing MariaDB...
helm install mariadb --set primary.nodeSelector."k3s\.io/hostname"=node3,auth.rootPassword=example,auth.database=bookedscheduler,auth.username=booked_user,auth.password=password bitnami/mariadb

kubectl label node node1 node-role.kubernetes.io/worker=worker
kubectl label node node2 node-role.kubernetes.io/worker=worker

echo Orchestrating deployments...
kubectl apply -f https://raw.githubusercontent.com/ChrisMott97/BookedScheduler/Final/kubernetes/booked.yaml
kubectl expose deployment booked --type="NodePort" --port 80
echo Booked accessible at $(getNodeIP "$master"):$(kubectl get service booked -o yaml | grep 'nodePort' | awk '{print $3}')
