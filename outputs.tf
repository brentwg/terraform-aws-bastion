# --------------
# Module Outputs
# --------------

# Route53
output "bastion_eip_address" {
  description = "The Bastion's public elastic IP address"
  value       = "${aws_eip.bastion_eip.public_ip}"
}

output "bastion_dns_name" {
  description = "The Bastion's fully qualified domain name"
  value       = "${aws_route53_record.bastion.fqdn}"
}


# IAM
output "bastion_role_arn" {
  description = "The Bastion's EC2 IAM role ARN"
  value       = "${aws_iam_role.bastion_role.arn}"
}

output "bastion_instance_profile_arn" {
  description = "The Bastion's EC2 instance profile ARN"
  value       = "${aws_iam_instance_profile.bastion_instance_profile.arn}"
}

output "bastion_instance_profile_name" {
  description = "The Bastion's EC2 instance profile name"
  value       = "${aws_iam_instance_profile.bastion_instance_profile.name}"
}
