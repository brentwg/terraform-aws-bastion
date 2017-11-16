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
  name = "${var.bastion_domain_name}"
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
resource "aws_iam_policy" "bastion_ec2_policy" {
  name        = "${var.customer_name}_${var.environment}_bastion_ec2_policy"
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
  policy_arn = "${aws_iam_policy.bastion_ec2_policy.arn}"
}


# ------------------------------
# Bastion CloudWatch Logs Policy
# ------------------------------
resource "aws_iam_policy" "bastion_logs_policy" {
  name        = "${var.customer_name}_${var.environment}_bastion_logs_policy"
  path        = "/"
  description = "${var.customer_name}_${var.environment} Bastion Logs Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}


# ----------------------------------
# Attach Bastion Logs Policy to Role
# ----------------------------------
resource "aws_iam_role_policy_attachment" "bastion_attach_logs_policy" {
  role       = "${aws_iam_role.bastion_role.name}"
  policy_arn = "${aws_iam_policy.bastion_logs_policy.arn}"
}


# ----------------------------
# Bastion EC2 Instance Profile
# ----------------------------
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.customer_name}_${var.environment}_bastion_instance_profile"
  role = "${aws_iam_role.bastion_role.name}"
}


# ---------------------------------------
# Render Bastion user_data bootstrap file
# ---------------------------------------
data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/bastion_userdata.sh")}"

  vars {
    REGION = "${var.bastion_region}"
    EIP_ID = "${aws_eip.bastion_eip.id}" 
  }
}


# ----------------------------
# Bastion Launch Configuration
# ----------------------------
resource "aws_launch_configuration" "bastion_launch_configuration" {
  name_prefix          = "${var.customer_name}_${var.environment}_bastion_lc-"
  image_id             = "${var.bastion_image_id}"
  instance_type        = "${var.bastion_instance_type}"
  key_name             = "${var.bastion_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion_instance_profile.name}"
  security_groups      = ["${var.bastion_security_groups}"]
  user_data            = "${data.template_file.bastion_user_data.rendered}"
  ebs_optimized        = "${var.bastion_ebs_optimized}"
  enable_monitoring    = "${var.bastion_enable_monitoring}"

  # Assign EIP in user_data instead 
  associate_public_ip_address = "false"

  root_block_device {
    volume_type = "${var.bastion_volume_type}"
    volume_size = "${var.bastion_volume_size}"
  }

  lifecycle {
    create_before_destroy = "true"
  }
}


# --------------------------
# Bastion Auto-Scaling Group
# --------------------------
resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "${var.customer_name}-${var.environment}_bastion_asg"
  max_size             = "${var.bastion_max_size}"
  min_size             = "${var.bastion_min_size}"
  desired_capacity     = "${var.bastion_desired_capacity}"
  launch_configuration = "${aws_launch_configuration.bastion_launch_configuration.name}"
  vpc_zone_identifier  = ["${var.bastion_asg_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.customer_name}-${var.environment}-bastion-asg"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = "true"
  }
}
