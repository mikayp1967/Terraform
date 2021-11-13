# Terraform examples/testing

## master branch for newer Terraform code/projects

## kube (TF 1.0.6 - random choice I know, not the first 1.0 version & not bleeding edge...)

I need a simple kube cluster to start testing on so here it is. 


## TF011 branch - code for Terraform 0.11.15


To use this you will need to be on branch TF011 otherwise pointing at modules 
and stuff won't work. This was just simple junk for the sake of doing some TF0.11 stuff 
so will likely not see much action

This is a small project to create a 2-tier network
The public tier will have ASG servers, NGW, IGW etc

The private tier will have a RDS instance

The "webservers" won't be fit for purpose, just basic AMIs but a proper
webserver AMI could be created with packer - see my other repo:
	git@github.com:mikayp1967/packer-builds.git

Similarly the RDS will have no schema, it's just really a an example of 
building the basic building blocks with terraform 

I've coded this in TF-0.11.15, there's a lot of legacy code around using
this version. I'll do future projects in newer TF



## old-stuff

This is some stuff I did a few years ago. I'm not sure exactly what
is in here, I need to tidy it up sometime
