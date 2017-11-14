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
