# Terraform examples/testing

Changing to have branch TO011 as the Terraform 0.11.15 version of the branch
Master will be TF12+ versions


## basic-nw (TF 0.11.15)

This is a small project to create a 2-tier network
The public tier will have ASG servers, NGW, IGW etc

The private tier will have a RDS instance

The "webservers" won't be fit for purpose, just basic AMIs but a proper
webserver AMI could be created with packer - see my other repo:
	git@github.com:mikayp1967/packer-builds.git

Similarly the RDS will have no schema, it's just really a an example of 
building the basic building blocks with terraform 

I've coded this in TF-0.11.15, there's a lot of legacy code around using
this version. 


## old-stuff

This is some stuff I did a few years ago. I'm not sure exactly what
is in here, I need to tidy it up sometime
