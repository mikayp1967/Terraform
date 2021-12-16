#!/bin/bash
# user_data for CP master node

sleep 10

sudo apt-get update
sudo hostnamectl set-hostname master-node
sudo apt install -y net-tools sysstat jq etcd-client


# Install containerd
sudo apt-get update -y
sudo apt-get install -y containerd
containerd config default | sudo tee /etc/containerd/config.toml


# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update


# Install/config AWS
sudo apt install -y awscli
cat  >  ~/.aws/config <<EOF
[default]
region = eu-west-2
EOF

# Add kube user/group to talk across machines
sudo groupadd -g 1200 kubegroup
sudo useradd -g 1200 -u 1200 -d /home/kubeuser -m -s /bin/bash kubeuser
sudo mkdir ~kubeuser/.ssh

sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa ~kubeuser/.ssh/id_rsa
aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~kubeuser/.ssh/id_rsa.pub
aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~kubeuser/.ssh/authorized_keys

sudo chmod 700 ~kubeuser/.ssh
sudo chmod 600 ~kubeuser/.ssh/*
sudo chown -R kubeuser:kubegroup ~kubeuser/.ssh



# Add kube packages
sudo apt-get install -y kubeadm kubelet kubectl kubernetes-cni
kubeadm version && kubelet --version && kubectl version



# This produces the kube connection string and we need that
sudo kubeadm init --cri-socket /run/containerd/containerd.sock --pod-network-cidr=192.168.0.0/24 --ignore-preflight-errors=all > /kube-join-command

sudo mkdir -p ~kubeuser/.kube
sudo cp -i /etc/kubernetes/admin.conf ~kubeuser/.kube/config
sudo chown -R kubeuser:kubegroup ~kubeuser/.kube

# Give kubeuser sudo
sudo usermod -a -G admin kubeuser
echo "kubeuser        ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Calico
# Changed pod network to 192... on kubeadm init so no need to edit it in the file...
curl https://docs.projectcalico.org/manifests/calico.yaml -O
mv calico.yaml ~kubeuser/calico.yaml
sudo chown  kubeuser:kubegroup ~kubeuser/calico.yaml
sudo su - kubeuser -c "kubectl apply -f calico.yaml"

# Configure for git
sudo -u kubeuser git config --global user.email "mikayp1967@gmail.com" 
sudo -u kubeuser   git config --global user.name "Michele Pietrantonio"


# Copy kube config file over (should make new one but meh...) and need to find the IP for it doh!

# Do upto 15 loops of checking for running instance with a 10s delay - close to 3 mins
for loop in `seq 1 15`; do
    NODE_STATE=$(aws ec2 describe-instances --region=eu-west-2 --filters Name=tag:Name,Values=NODE1|jq -r '.Reservations[].Instances[] | select (.State.Name == "running" )|.State.Name')
    if [ "${NODE_STATE}" = "running" ]; then
        break
    fi
    sleep 10                    # Yes, delay AFTER the node is running - lets give it that extra 10s
done
# Still got timing delays while node does its startup stuff so give it another 60s
sleep 60



