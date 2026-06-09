data "aws_subnet" "selected" {
    filter {
        name   = "tag:Name"
        values = ["subnet-1"] #fetch the subnet with the tag Name=subnet-1
    }
}
data "aws_security_group" "selected" {
    filter {
        name   = "tag:Name"
        values = ["my-security-group"] #fetch the security group with the tag Name=my-security-group
    }
}

resource "aws_instance" "name" {
    ami           = "ami-0152204c1a187337c"
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.selected.id #use the id of the fetched subnet
    vpc_security_group_ids = [data.aws_security_group.selected.id] #use the id of the fetched security group
    tags = {
        Name = "my-ec2-instance"
    }
  
}