
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns

  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_subnet" "pub_sbn" {
  count                   = var.sbn_cnt
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 10 + (count.index * 10))
  map_public_ip_on_launch = true
  availability_zone       = var.az_list[count.index % 3]
  tags = {
    "Name" = "${var.tag_name}-pub-${count.index + 1}"
    "Cost" = var.tag_cost
  }
}

resource "aws_subnet" "pvt_sbn" {
  count                   = var.sbn_cnt
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 10 + length(aws_subnet.pub_sbn) * 10 + (count.index * 10))
  map_public_ip_on_launch = true
  availability_zone       = var.az_list[count.index % 3]
  tags = {
    "Name" = "${var.tag_name}-pvt-${count.index + 1}"
    "Cost" = var.tag_cost
  }
}

resource "aws_eip" "eip" {
  count      = var.sbn_cnt
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw" {
  count         = var.sbn_cnt
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.pub_sbn[count.index].id

  tags = {
    "Name" = "${var.tag_name}-ngw-${count.index + 1}"
    "Cost" = var.tag_cost
  }
  depends_on = [aws_internet_gateway.igw]


}


resource "aws_route_table" "rtb_pub" {
  count  = var.sbn_cnt
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.tag_name}-rtb-${count.index + 1}"
    "Cost" = var.tag_cost
  }
}

resource "aws_route" "dgw_pub" {
  count                  = var.sbn_cnt
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rtb_pub[count.index].id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rtb_pub_assoc" {
  count          = var.sbn_cnt
  subnet_id      = aws_subnet.pub_sbn[count.index].id
  route_table_id = aws_route_table.rtb_pub[count.index].id
}


resource "aws_route_table" "rtb_pvt" {
  count  = var.sbn_cnt
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.tag_name}-trb-${count.index + 1}"
    "Cost" = var.tag_cost
  }
}

resource "aws_route" "dgw_pvt" {
  count                  = var.sbn_cnt
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rtb_pvt[count.index].id
  gateway_id             = aws_nat_gateway.ngw[count.index].id
}

resource "aws_route_table_association" "rtb_pvt_assoc" {
  count          = var.sbn_cnt
  subnet_id      = aws_subnet.pvt_sbn[count.index].id
  route_table_id = aws_route_table.rtb_pvt[count.index].id
}


