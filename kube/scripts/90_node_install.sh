#!/bin/bash
# user_data for CP master node
#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y kubeadm kubelet kubectl
kubeadm version && kubelet --version && kubectl version

# Install/config AWS
sudo apt install -y awscli
cat  >  ~/.aws/config <<EOF
[default]
region = eu-west-2
EOF

# Configure user so CP can ssh across
sudo groupadd -g 1200 kubegroup
sudo useradd -g 1200 -u 1200 -d /home/kubeuser -m -s /bin/bash kubeuser
sudo mkdir ~kubeuser/.ssh
sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~kubeuser/.ssh/authorized_keys
#sudo aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa ~kubeuser/.ssh/id_rsa
sudo chown -R kubeuser:kubegroup ~kubeuser/.ssh
sudo chmod 700 ~kubeuser/.ssh
sudo chmod 600 ~kubeuser/.ssh/*
sudo chmod 644 ~kubeuser/.ssh/id_rsa.pub


