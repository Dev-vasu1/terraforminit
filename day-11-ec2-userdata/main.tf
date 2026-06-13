resource "aws_instance" "name" {
    ami           = "ami-00e801948462f718a"
    instance_type = "t3.micro"
    subnet_id = "subnet-037b27c79dcec6cc2"
        user_data = <<-EOF
                #!/bin/bash
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello, World! modifi new one"> /var/www/html/index.html
                EOF        
    tags = {
        Name = "My EC2 Instance"
    }
  
}