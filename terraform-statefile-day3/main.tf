resource "aws_instance" "name" {
  ami           = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  subnet_id     = "subnet-07c58c00bfb20e8cc"

}