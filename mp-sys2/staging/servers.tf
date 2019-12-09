module "vpc_module" {
    source = "../modules/net_module"
}


module "my_ec2" {
    source = "../modules/ec2_module"
    instance_type = "t2.nano"
    ec2_name = "staging"
    #subnet_id =  "${module.vpc_module.public_subnet_a}"
    subnet_id_a =  "${module.vpc_module.public_subnet_a}"
    subnet_id_b =  "${module.vpc_module.public_subnet_b}"
#    availability_zone="${var.availability_zone}"
}

