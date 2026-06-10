module "test" {
    source = "../day-9-modules"
    name = "test-instance11"
    ami_id = "ami-0152204c1a187337c"
    subnet_id =  "subnet-037b27c79dcec6cc2"
    instance_type = "t3.micro"
}