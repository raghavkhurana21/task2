resource "aws_vpc" "raghav_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.raghav_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.raghav_vpc.id

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }

}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.raghav_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }
}
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_instance" "web" {
  ami             = "ami-0376ec8eacdf70aae"
  instance_type   = "t2.micro"
  key_name      = aws_key_pair.tf-key-pairr.key_name
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.raghav_sgroup.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/")

    bastion_host = "172.31.1.90"
    bastion_user = "ASUS"
    bastion_private_key = file("~/")
  } 

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }

  volume_tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }
}
resource "aws_key_pair" "tf-key-pairr" {
key_name = "my-key-pairr"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}

resource "aws_security_group" "raghav_sgroup" {
  name        = "raghavsg"
  vpc_id      = aws_vpc.raghav_vpc.id
  description = "sgroup"
#   dynamic "ingress" {
#     for_each = [80, 443, 22]
#     iterator = port
#     content {
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
  

 # }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.90/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "vpc-raghav"
    Owner   = "raghav.khurana@cloudeq.com"
    Purpose = "terraform task"
  }
}


#---------------------------------------------------------------------------------------------------------------------------------------------

# resource "aws_vpc" "app_vpc" {
#   cidr_block = var.vpc_cidr

#   tags = {
#     Name = "app-vpc"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.app_vpc.id

#   tags = {
#     Name = "vpc_igw"
#   }
# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.app_vpc.id
#   cidr_block        = var.public_subnet_cidr
#   map_public_ip_on_launch = true
#   availability_zone = "us-west-2a"

#   tags = {
#     Name = "public-subnet"
#   }
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.app_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "public_rt"
#   }
# }

# resource "aws_route_table_association" "public_rt_asso" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_rt.id
# }