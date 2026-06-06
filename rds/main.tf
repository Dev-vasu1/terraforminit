resource "aws_db_instance" "default" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"

    username             = "admin"
    password             = "vasudev121"
    parameter_group_name = "default.mysql8.0"   
    

  
}
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main"
    }
    }
    resource "aws_subnet" "private_1" {
    vpc_id            = aws_vpc.default.id 
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "private-1"
    }
    }
    resource "aws_subnet" "private_2" {
    vpc_id            = aws_vpc.default.id 
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1c"
    tags = {
        Name = "private-2"
    }
    }
    #resource "aws_db_instance" "default" {
resource "aws_db_subnet_group" "default" {
  name = "main"

  subnet_ids = [
    aws_subnet.private_1.id, # us-east-1a
    aws_subnet.private_2.id  # us-east-1c
  ]

  tags = {
    Name = "My DB subnet group"
  }
}