#this is the main file.
provider "aws"{
    access_key = "${var.aws_access_key}"
    secret_ker = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}


resource "aws_instance" "terraform_test"{
    ami = "${lookup(var.ami , var.aws_ami)}"
    instance_type = "t2.micro"
}

resource "aws_vpc" "default" {
  cidr_block = "___________"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_elb_attachment" "elb"{
    elb = "${aws_elb.bar.id}"
    instance = ${aws_instance.foo.id}"
}


provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install nginx",
      "sudo systemctl enable nginx.service",
      "sudo service nginx start",
    ]
}


#this will define the way we connect.
connection {
    type = "ssh"
    user = "ec2"
    private_key = "${file("___________")}"
}


#this will output the ip address.
output "ip_address"{
    value = "$aws_instance.terraform_test.public_ip"
}


#Variables will be stored in environment variables and will be taken automatically by Terraform.
variable aws_access_key{}
variable aws_secret_key{}
variable "aws_region"{
    default = "ap-south-1"
}


#the lookup table for amis.
variable "aws_ami"{
    "us-east-1" = "ami-08bc77a2c7eb2b1da"
    "ap-south-1" = "ami-54d2a63b"
}