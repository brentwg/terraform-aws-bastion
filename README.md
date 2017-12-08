# Terraform AWS EC2 Bastion Server Module (with ASG)
This is a Terraform module used to create an AWS EC2 Bastion instance which runs in autoscaling group (ASG).  

The ASG attempts to ensure that at exactly 1 Bastion instance is running and the module ensures that this instance is always assigned 
an Elastic IP which is already registered in Route53 and corresponds to the DNS name `bastion.your-domain.whatever`.  


## Dependencies

### Amazon AWS AMI
This module requires that a custom Bastion AMI be created in whichever region you will deploy. To automate the creation of the AMI, I used [Packer](https://www.packer.io/) and [Ansible](https://www.ansible.com/).  

To create your own Bastion AMI, use this repo: [Packer - AWS Bation AMI](https://github.com/brentwg/packer-aws-bastion).  

### Amazon Resources  
- VPC
- Elastic IP
- Route53 records set (for `bastion.your-domain.whatever`)
- SSH Key Pair
### Required Variables  
```
# Project
customer_name: The project's customer
environment:   dev, test, poc, uat, prod

# DNS
route53_zone_id:     your-domain's Route53 zone ID
bastion_domain_name: your-domain.whatever
bastion_zone_ttl:    Time-to-live for the zone record

# Launch Configuration
bastion_region:             region into which you intend to deploy
bastion_instance_type:      EC2 instance type
bastion_key_name            SSH key pair name
bastion_security_groups:    Bastion's security group ID
bastion_enable_monitoring:  True to enable detailed monitoring
bastion_volume_type:        Root volume type
bastion_volume_size:        Root volume size (GB)

# Auto-Scaling Group
bastion_max_size:         Max # of required Bastions
bastion_min_size:         Min # of required Bastions
bastion_desired_capacity: # of Bastions that should always be running
bastion_asg_subnets:      Subnet into which you intend to deploy the ASG
```

## Example Usage  
```
# -------
# Bastion
# -------
module "bastion" {
  source = "../<path-to>/terraform-aws-bastion"

  customer_name       = "thisCustomer"
  environment         = "prod"

  # Route53
  bastion_zone_id     = "${data.aws_route53_zone.my_domain.zone_id}"
  bastion_domain_name = "bastion.${var.domain_name}"
  bastion_zone_ttl    = "300"

  # Launch config
  bastion_region        = "${var.region}"      
  bastion_image_id      = "ami-yourID"
  bastion_instance_type = "t2.micro"
  bastion_key_name      = "your_keypair"

  bastion_security_groups   = [
    "${module.bastion_security_group.bastion_security_group_id}"
  ]
  
  bastion_ebs_optimized     = "false"
  bastion_enable_monitoring = "false"
  bastion_volume_type       = "gp2"
  bastion_volume_size       = "8"

  # ASG
  bastion_max_size         = "1"
  bastion_min_size         = "1"
  bastion_desired_capacity = "1"

  bastion_asg_subnets      = ["${module.vpc.public_subnets}"]
}

```
