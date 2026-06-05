# Configure the AWS provider
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"


    tags = {
        Name = "network-vpc1"
  
}
}
#   Create a subnet in the VPC public subnet
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "network-subnet1"
    }
}
#   Create a subnet in the VPC private subnet
resource "aws_subnet" "main2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "network-subnet2"
    }
}
#   Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "network-gw1"
    }
}
#   Create a route table and associate it with the public subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
}
#   Associate the route table with the private subnet
resource "aws_route_table_association" "private_assoc" {
    subnet_id = aws_subnet.main2.id
    route_table_id = aws_route_table.private.id
}
#   Create a security group that allows inbound SSH traffic
resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"
    description = "Allow SSH inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#creation of elastic ip for nat gateway
resource "aws_eip" "nat" {
  domain   = "vpc"
}
#   Create a NAT gateway in the public subnet
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.subnet1.id
    tags = {
        Name = "network-nat1"
    }
}
#   Create an EC2 instance in the public subnet to act as a NAT instance
resource "aws_instance" "nat" {
    ami = "ami-00e801948462f718a"
    instance_type = "t3.micro"

    tags = {
        Name = "network-22"
    }
}