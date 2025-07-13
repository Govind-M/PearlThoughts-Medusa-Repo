data "aws_vpc" "default"{
    default = true
}

resource "aws_subnet" "public_subnet"{
    count = 2
    vpc_id = data.aws_vpc.default.id
    cidr_block = cidrsubnet(data.aws_vpc.default.cidr_block,8,count.index+64)
    availability_zone = element(["ap-south-1a","ap-south-1b"],count.index)
    tags = {
      name = "medusa-deploy-public-subnet-$(count.index)"
    }
    map_public_ip_on_launch = true
}


data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = data.aws_vpc.default.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.default_igw.id
    }
    tags = {
      name = "Public-RouteTable"
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    count = 2
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet[count.index].id
}



resource "aws_security_group" "medusa_sg" {
    name        = "medusa_backend_sg"
    vpc_id      = data.aws_vpc.default.id

    ingress {
    protocol        = "tcp"
    from_port       = 9000
    to_port         = 9000
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open for now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
