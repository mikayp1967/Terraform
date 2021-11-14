#!/bin/bash
# user_data for CP master node
#!/bin/bash

sudo apt-get update
sudo hostnamectl set-hostname master-node
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
sudo chown -R kubeuser:kubegroup ~kubeuser/.ssh
sudo chmod 700 ~kubeuser/.ssh
sudo chmod 600 ~kubeuser/.ssh/id_rsa
aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa



# Install docker
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# CE-VERS=$(apt-cache madison docker-ce|head -1|awk '{print $3}')
sudo usermod -a -G docker kubeuser 
sudo usermod -a -G docker ubuntu
# Change cgroups config        https://stackoverflow.com/questions/52119985/kubeadm-init-shows-kubelet-isnt-running-or-healthy
sudo cat > /etc/docker/daemon.json << EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF


# Add kube packages
sudo apt-get install -y kubeadm kubelet kubectl
kubeadm version && kubelet --version && kubectl version



# This produces the kube connection string and we need that
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all|grep "kubeadm join" > /kube-join-command
mkdir -p $HOME/.kube
sudo cp -i /etc/Kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

