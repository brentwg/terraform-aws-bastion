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


# ----------------
# Bastion EC2 Role
# ----------------
resource "aws_iam_role" "bastion_role" {
  name = "${var.customer_name}_${var.environment}_bastion_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# ------------------
# Bastion EC2 Policy
# ------------------
resource "aws_iam_policy" "bastion_policy" {
  name        = "${var.customer_name}_${var.environment}_bastion_policy"
  path        = "/"
  description = "${var.customer_name}_${var.environment} Bastion EC2 Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1477071439000",
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


# ---------------------------------
# Attach Bastion EC2 Policy to Role
# ---------------------------------
resource "aws_iam_role_policy_attachment" "bastion_attach_ec2_policy" {
  role       = "${aws_iam_role.bastion_role.name}"
  policy_arn = "${aws_iam_policy.bastion_policy.arn}"
}


# ----------------------------
# Bastion EC2 Instance Profile
# ----------------------------
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.customer_name}_${var.environment}_bastion_instance_profile"
  role = "${aws_iam_role.bastion_role.name}"
}
