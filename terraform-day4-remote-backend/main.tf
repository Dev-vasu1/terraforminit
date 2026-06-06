resource "aws_instance" "name" {
    ami           = "ami-00e801948462f718a"
    instance_type = "t3.micro"
    subnet_id = "	subnet-037b27c79dcec6cc2"
    tags = {
        Name = "My EC2 Instance"
    }
  
}