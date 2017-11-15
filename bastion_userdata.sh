#!/usr/bin/env bash

INSTANCEID=$(curl -s -m 60 http://169.254.169.254/latest/meta-data/instance-id)
aws --region ${REGION} ec2 associate-address --instance-id $INSTANCEID --allocation-id ${EIP_ID}
