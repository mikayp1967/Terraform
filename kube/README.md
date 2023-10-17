## kube (TF 1.0.6 - random choice I know, not the first 1.0 version & not bleeding edge...)

I need a simple kube cluster to start testing on so here it is. 
Done a few bits so far but I am going to very much focus on not spending money so 
it will likely have the least possible infrastructure, 1 CP 1 node initially
Least networking features etc etc...

This repo is going to be the barest of bones infra build so anything that 
happens once the cluster is up will go in a different location


## Current Status

* basic network
* 1 "CP" node, just a ubuntu20 box with some kube binaries
* 1 Node box in "private" SN
* EIP on CP so no bastion server needed (save $$, this ain't prod)
* Add an S3 for certs (created outside TF but IAM role created)
* Node should successfully join the cluster now
* Installed etcdctl, gonna put backup script in the kube repo...
* Change runtime form docker to containerd


## To Do

* KMS on those S3s - lets be fair, won't ever happen.
* Role for EC2s is gonna be messy when I need to add permissions - this can prob wait forever
* Done some kind of node scaling - ASG?
* Could add some magic to kubeadm to change behavious of core omponents


## Notes

I have a repo that can create packer builds but that's $$ for storage
so I will just use user_data on the instances to install stuff. 

Credit where it's due - I used the following resources for the kube install scripts:
https://adamtheautomator.com/install-kubernetes-ubuntu/
https://www.howtoforge.com/setup-a-kubernetes-cluster-on-aws-ec2-instance-ubuntu-using-kubeadm/
https://www.fosstechnix.com/how-to-install-kubernetes-cluster-on-ubuntu/
https://linuxconfig.org/how-to-install-kubernetes-on-ubuntu-20-04-focal-fossa-linux


## Usage

Log in to master node as kubeuser where kubectl is configured.
