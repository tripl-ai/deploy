# network.tf

# Fetch AZs in the current region
data "aws_availability_zones" "available" {

}

resource "aws_vpc" "main" {
  cidr_block           = "172.18.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "arcdemo_vpc"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "arcdemo_igw"
  }
}

# ====================================================================================
# ================================ Create Subnet =====================================
# ====================================================================================

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "arcdemo_private_subnet"
  }
}
# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "arcdemo_pub_subnet"
  }
}

# ====================================================================================
# ============================== Create Route table ==================================
# ====================================================================================

# # Route table: attach Internet Gateway 
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "arcdemo_pub_rtbl"
#   }
# }

# # Route table association with public subnets
# resource "aws_route_table_association" "public" {
#   count          = var.az_count
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = aws_route_table.public.id


# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ====================================================================================
# ============================= NAT For Private Subnet =============================== 
# =========== If ECS task doesn't need internet connection, no need NAT ==============
# ====================================================================================

# # Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
# resource "aws_eip" "gw" {
#   count      = var.az_count
#   vpc        = true
#   depends_on = [aws_internet_gateway.igw]

#   tags = {
#     Name = "arcdemo_eip"
#   }
# }
# resource "aws_nat_gateway" "gw" {
#   count         = var.az_count
#   subnet_id     = element(aws_subnet.public.*.id, count.index)
#   allocation_id = element(aws_eip.gw.*.id, count.index)

#   tags = {
#     Name = "arcdemo_nat"
#   }
# }

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  # count  = var.az_count
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  # }

  tags = {
    Name = "arcdemo_private_rtbl"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

  depends_on = [aws_subnet.private, aws_route_table.private]
}

# ====================================================================================
# =========================== VPC Endpoints (PrivateLink) ============================
# ====================================================================================

## . ETL jobs in ECS doesn't need go to the public network
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private.*.id

  tags = {
    Name = "arcdemo_s3_endpoint"
  }
}


resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint.id]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private.*.id

  tags = {
    Name = "arcdemo_ecs_endpoint"
  }
}


resource "aws_vpc_endpoint" "ecstelemetry" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint.id]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private.*.id

  tags = {
    Name = "arcdemo_ecs_endpoint"
  }
}


resource "aws_vpc_endpoint" "ecrdkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint.id]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private.*.id

  tags = {
    Name = "arcdemo_ecr_endpoint"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoint.id]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private.*.id

  tags = {
    Name = "arcdemo_logs_endpoint"
  }
}
