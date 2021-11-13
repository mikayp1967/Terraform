#!/bin/bash

# Script to complete install of master/CP node
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.0.0.200

