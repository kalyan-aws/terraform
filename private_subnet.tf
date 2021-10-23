resource "aws_subnet" "private_subnet" {
  count                   = length(slice(local.az_names, 0, 2))
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index + length(local.az_names))
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "POC-privateRT"
  }
}

resource "aws_route_table_association" "privassoc" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.privateRT.id

}