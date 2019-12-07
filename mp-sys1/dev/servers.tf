module "my_ec2" {
    source = "../modules/ec2_module"
    instance_type = "t2.nano"
    ec2_name = "my_devEC2"
#    subnet_id = "${module.my_vpc.subnet_id}"
    subnet_id = "subnet-0d44efe1e45c20546"
}

