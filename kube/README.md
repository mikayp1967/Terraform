## kube (TF 1.0.6 - random choice I know, not the first 1.0 version & not bleeding edge...)

I need a simple kube cluster to start testing on so here it is. 
Done a few bits so far but I am going to very much focus on not spending money so 
it will likely have the least possible infrastructure, 1 CP 1 node initially
Least networking features etc etc...

So far I have:
* basic network
* 1 "CP" node, just a ubuntu20 box with some kube binaries
* 1 Node box in "private" SN
* EIP on CP so no bastion server needed (save $$, this ain't prod)
* Add an S3 for certs (created outside TF but IAM role created)
* node should have external access now


To do:
* Finalise the user_data to install K8s on CP & Node (need to try spinning it up, should just be join string)
* KMS on those S3s
* Role for EC2s is gonna be messy when I need to add permissions - this can prob wait forever

* Work the rest out when I've done this

## Issues

No real idea how I'll scale nodes up - but I need to read up on that anyway



## Notes

I have a repo that can create packer builds but that's $$ for storage
so I will just use user_data on the instances to install stuff. 

Credit where it's due - I used the following resources for the kube install scripts:
https://adamtheautomator.com/install-kubernetes-ubuntu/
https://www.howtoforge.com/setup-a-kubernetes-cluster-on-aws-ec2-instance-ubuntu-using-kubeadm/
https://www.fosstechnix.com/how-to-install-kubernetes-cluster-on-ubuntu/
https://linuxconfig.org/how-to-install-kubernetes-on-ubuntu-20-04-focal-fossa-linux
