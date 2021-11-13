## kube (TF 1.0.6 - random choice I know, not the first 1.0 version & not bleeding edge...)

I need a simple kube cluster to start testing on so here it is. 
Done a few bits so far but I am going to very much focus on not spending money so 
it will likely have the least possible infrastructure, 1 CP 1 node initially
Least networking features etc etc...

So far I have:
* basic network
* 1 "CP" node, just a ubuntu20 box with some kube binaries
* EIP on CP so no bastion server needed (save $$, this ain't prod)

To do:
* Add 1+ node instance
* Might need an S3 for certs
* Finalise the user_data to install K8s on CP & Node
* Work the rest out when I've done this


Credit where it's due - I ripped the above Kube install stuff (+ some tweaks) from:
https://adamtheautomator.com/install-kubernetes-ubuntu/

