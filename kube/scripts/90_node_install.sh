#!/bin/bash
# user_data for CP master node

sudo apt-get update
# sudo hostnamectl set-hostname node1


sudo apt install -y net-tools sysstat jq


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
sudo usermod -a -G docker ubuntu
# Change cgroups config        https://stackoverflow.com/questions/52119985/kubeadm-init-shows-kubelet-isnt-running-or-healthy
sudo cat > /etc/docker/daemon.json << EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl restart docker
sudo systemctl enable docker
sudo swapoff -a

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update

# Configure user so CP can ssh across
sudo groupadd -g 1200 kubegroup
sudo useradd -g 1200 -u 1200 -d /home/kubeuser -m -s /bin/bash kubeuser
sudo mkdir ~kubeuser/.ssh

# Install/config AWS
sudo apt install -y awscli
sudo mkdir ~kubeuser/.aws
sudo cat  >  ~kubeuser/.aws/config <<EOF
[default]
region = eu-west-2
EOF
sudo chown -R kubeuser:kubegroup  ~kubeuser/.aws

sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~kubeuser/.ssh/authorized_keys
sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~kubeuser/.ssh/id_rsa.pub
sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa ~kubeuser/.ssh/id_rsa
sudo chown -R kubeuser:kubegroup ~kubeuser/.ssh
sudo usermod -a -G docker kubeuser
sudo chmod 700 ~kubeuser/.ssh
sudo chmod 600 ~kubeuser/.ssh/*
# sudo chmod 644 ~kubeuser/.ssh/id_rsa.pub


# Add kube packages
sudo apt-get install -y kubeadm kubelet kubectl kubernetes-cni
kubeadm version && kubelet --version && kubectl version

# Add kubeuser to admin group (for sudo)
sudo usermod -a -G admin kubeuser
echo "kubeuser        ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure for git
sudo -u kubeuser git config --global user.email "mikayp1967@gmail.com" 
sudo -u kubeuser   git config --global user.name "Michele Pietrantonio"

# Join cluster
# This needs fixing to get the CP IP
cat <<EOF|sudo -u kubeuser tee ~kubeuser/join_cluster.sh
#!/bin/bash
MAST_IP=\$(aws ec2 describe-instances --region=eu-west-2 --filters Name=tag:Name,Values=CP1|jq -r '.Reservations[].Instances[]| select (.State.Name == "running" )|.PrivateIpAddress')
JOINCMD=\$(ssh -o "StrictHostKeyChecking=no" kubeuser@\${MAST_IP} kubeadm token create --print-join-command)
sudo \${JOINCMD}
mkdir ~/.kube
scp kubeuser@\${MAST_IP}:~/.kube/config ~/.kube/config
EOF

sudo chmod 755  ~kubeuser/join_cluster.sh
sudo -u kubeuser ~kubeuser/join_cluster.sh
