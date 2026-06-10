resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My VPC"
  }
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  tags = {
    Name = "My Subnet1"
  } 
}
resource "aws_subnet" "name2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "My Subnet2"
    }
  }
resource "aws_db_subnet_group" "name" {
    name = "my-db-subnet-group"
    subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
    tags = {
        Name = "My DB Subnet Group"
    }
}
resource  "aws_security_group" "name" {
    name = "my-db-security-group"
    description = "Allow MySQL traffic"
    vpc_id = aws_vpc.name.id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_db_instance" "primary" {
  identifier             = "my-rds-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.name.name
  vpc_security_group_ids = [aws_security_group.name.id]
  skip_final_snapshot    = true
  username               = "admin"
  password               = var.db_password
  #manage_master_user_password = true #enable password management by AWS Secrets Manager
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
  backup_retention_period = 1


}
 # Create a read replica of the primary RDS instance
resource "aws_db_instance" "read_replica" {
  identifier = "my-rds-read-replica"
# replace with the ARN of your primary RDS instance
  replicate_source_db = aws_db_instance.primary.arn

  instance_class = "db.t3.micro"

  db_subnet_group_name   = aws_db_subnet_group.name.name
  vpc_security_group_ids = [aws_security_group.name.id]

  publicly_accessible = false

  skip_final_snapshot = true
}
resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name = "my-redis-subnet-group"
  subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
}
resource  "aws_security_group" "redis_security_group" {
    name = "redis-security-group"
    description = "Allow Redis traffic"
    vpc_id = aws_vpc.name.id
    ingress {
        from_port = 6379
        to_port = 6379   
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}