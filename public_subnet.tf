locals {
  az_names = data.aws_availability_zones.azs.names
}
resource "aws_subnet" "public_subnet" {
  count                   = length(local.az_names)
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "POC-IGW"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "POC-pubicRT"
  }
}

resource "aws_route_table_association" "assoc" {
  count          = length(local.az_names)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.PublicRT.id
}