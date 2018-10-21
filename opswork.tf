provider "aws" {
  access_key = "${var.access_key}",
  secret_key = "${var.secret_key}",
  region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  assign_generated_ipv6_cidr_block    = "false"
  enable_classiclink   = "false"
  tags {
    Name = "TAG_TAG_TAG"
  }
}

#Create ec2 instance in existing VPC
resource "aws_instance" "web" {
  instance_type = "t2.micro"
  availability_zone = "${var.aws_region}"
  key_name        = "user"
  ami = "ami-00035f41c82244dab"
  security_groups = [ "${aws_security_group.FrontEnd.id}" ]
  source_dest_check = "false"
  user_data = "${file("install.sh")}"
  tags {
    Name = "TAG_TAG_TAG"
  }
}

#Create new EBS volume with "magnetic" type, 1GB size
resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "eu-west-1c"
    type = "standard"
    size = 1
    tags {
      Name = "TAG_TAG_TAG"
    }
}

#mount additional volume
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/sda2"
   volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.web.id}"
}

#Create security group which allows only 22 and 80 inbound ports and attach it to the instance.
resource "aws_security_group" "FrontEnd" {
  name = "TAG_TAG_TAG_group"
  description =  "Security group created by TAG_TAG_TAG for ingress ports 22,80"

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_key_pair" "user" {
    key_name = "key_TAG_TAG_TAG"
    public_key = "${file("ssh/user.pub")}"
}

variable "aws_region" {
  default     = "eu-west-1"
}
