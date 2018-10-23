provider "aws" {
  access_key = "${var.access_key}",
  secret_key = "${var.secret_key}",
  region = "${var.aws_region}"
}

#Create ec2 instance in existing VPC
resource "aws_instance" "web" {
  count = 1
  instance_type = "t2.micro"
  availability_zone = "eu-west-1c"
  ami = "ami-a8d2d7ce"
  vpc_security_group_ids = [ "${aws_security_group.OEvgeniy_group.id}" ]
  source_dest_check = "false"

  #Create new EBS volume with "magnetic" type, 1GB size
  ebs_block_device {
    device_name           = "/dev/sda2"
    volume_type           = "standard"
    volume_size           = 1
    delete_on_termination = false
  }
  user_data = "${file("./attach_ebs.sh")}" 
  key_name = "key_Evgenij"
  provisioner "file" {
        source      = "./install.sh"
        destination = "/tmp/install.sh"

        connection {
            type     = "ssh"
            user     = "ubuntu"
            private_key = "${file("./ssh/key_oEvgen.pem")}"
        }
    }

    provisioner "remote-exec" {
        inline = [
             "chmod +x /tmp/install.sh",
             "/tmp/install.sh"
        ]
        connection {
            type     = "ssh"
            user     = "ubuntu"
            private_key = "${file("./ssh/key_oEvgen.pem")}"
        }
    }
    

  tags {
    Name = "TAGS_TAGS"
  }
}

output "node_dns_name" {
    value = "${aws_instance.web.public_dns}"
}


#Create security group which allows only 22 and 80 inbound ports and attach it to the instance.
resource "aws_security_group" "OEvgeniy_group" {
  name = "OEvgeniy_group"
  description =  "ingress ports 22,80"

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

    # Open up outbound internet access
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

 tags {
      Name = "TAGS_TAGS"
    }
}

resource "aws_key_pair" "key_Evgenij" {
    key_name = "key_Evgenij"
    public_key = "${file("./ssh/key.pem")}"
}

variable "aws_region" {
  default     = "eu-west-1"
}
