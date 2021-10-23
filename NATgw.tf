resource "aws_eip" "example" {

  tags = {
    "Name" = "EIP"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public_subnet.*.id[0]

  tags = {
    Name = "NATGW"
  }
  depends_on = [aws_internet_gateway.igw]
}