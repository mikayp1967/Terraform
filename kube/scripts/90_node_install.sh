#!/bin/bash
# user_data for CP master node

sleep 15		# Some stuff didn't install 1 run so let cloud init finish 

sudo apt-get update
sudo apt install -y net-tools sysstat jq


# ----- Install containerd
# Dunno why the following sections don't seem to be required on the master...
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo apt-get update -y
sudo apt-get install -y containerd
mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml


# ----- Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# **** Move this down later.
sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update

# ----- Configure user so CP can ssh across
sudo groupadd -g 1200 kubegroup
sudo useradd -g 1200 -u 1200 -d /home/kubeuser -m -s /bin/bash kubeuser
sudo mkdir ~kubeuser/.ssh

# ----- Install/config AWS
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
sudo chmod 700 ~kubeuser/.ssh
sudo chmod 600 ~kubeuser/.ssh/*
# sudo chmod 644 ~kubeuser/.ssh/id_rsa.pub


# ----- Add kube packages
sudo apt-get install -y kubeadm kubelet kubectl kubernetes-cni
kubeadm version && kubelet --version && kubectl version

# ----- Add kubeuser to admin group (for sudo)
sudo usermod -a -G admin kubeuser
echo "kubeuser        ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# ----- Configure for git
sudo -u kubeuser git config --global user.email "mikayp1967@gmail.com" 
sudo -u kubeuser   git config --global user.name "Michele Pietrantonio"

# ----- Join cluster
cat <<EOF|sudo -u kubeuser tee ~kubeuser/join_cluster.sh
#!/bin/bash
MAST_IP=\$(aws ec2 describe-instances --region=eu-west-2 --filters Name=tag:Name,Values=CP1|jq -r '.Reservations[].Instances[]| select (.State.Name == "running" )|.PrivateIpAddress')
JOINCMD=\$(ssh -o "StrictHostKeyChecking=no" kubeuser@\${MAST_IP} kubeadm token create --print-join-command)
sudo \${JOINCMD}
mkdir -p ~/.kube
scp kubeuser@\${MAST_IP}:~/.kube/config ~/.kube/config
EOF

sudo chmod 755  ~kubeuser/join_cluster.sh
sudo -u kubeuser ~kubeuser/join_cluster.sh >  ~kubeuser/join_cluster.log
