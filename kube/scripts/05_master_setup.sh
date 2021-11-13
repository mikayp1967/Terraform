#!/bin/bash

# Configure local aws config
mkdir ~/.aws
cat  >  ~/.aws/config <<EOF
[default]
region = eu-west-2
EOF


# Copy key to log to other nodes from s3
#if [ ! -d "~/.ssh" ]; then
#  aws s3  cp s3://key-store-bucket-390490349038000/kube-project-keys/id_rsa.pub ~/.ssh/id_rsa.pub
#  mod 600 ~/.ssh/id_rsa.pub
#fi

