# ------------------
# Bastion Elastic IP
# ------------------
resource "aws_eip" "bastion_eip" {
  vpc = "true"
}


# ----------------------
# Bastion Route53 Record
# ----------------------
resource "aws_route53_record" "bastion" {
  zone_id = "${var.bastion_zone_id}"
  name = "bastion.${var.bastion_domain_name}"
  type = "A"
  ttl = "${var.bastion_zone_ttl}"

  records = ["${aws_eip.bastion_eip.public_ip}"]
}
