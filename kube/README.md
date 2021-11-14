## kube (TF 1.0.6 - random choice I know, not the first 1.0 version & not bleeding edge...)

I need a simple kube cluster to start testing on so here it is. 
Done a few bits so far but I am going to very much focus on not spending money so 
it will likely have the least possible infrastructure, 1 CP 1 node initially
Least networking features etc etc...

So far I have:
* basic network
* 1 "CP" node, just a ubuntu20 box with some kube binaries
* 1 Node box
* EIP on CP so no bastion server needed (save $$, this ain't prod)
* Add an S3 for certs (created outside TF but IAM role created)


To do:
* Finalise the user_data to install K8s on CP & Node
* KMS on those S3s
* kubeadm install is failing - fix that
* Node is in same az as CP - need to add routes there so diff subnets can talk
* Node needs to access internet...
* Role for EC2s is gonna be mesy when I need to add permissions - this can prob wait forever

* Work the rest out when I've done this


## Notes

I have a repo that can create packer builds but that's $$ for storage
so I will just use user_data on the instances to install stuff. 

Credit where it's due - I ripped the above Kube install stuff (+ some tweaks) from:
https://adamtheautomator.com/install-kubernetes-ubuntu/

