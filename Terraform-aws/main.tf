data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_s3_bucket" "profile_images" {
  bucket = var.bucket_name

  tags = {
    Project     = "User-Profile-App"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
resource "aws_iam_role" "profile_app_role" {
  name = "profile-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_instance_profile" "profile_app_profile" {

  name = "profile-app-instance-profile"

  role = aws_iam_role.profile_app_role.name
}
resource "aws_iam_policy" "profile_app_s3_policy" {

  name = "profile-app-s3-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "s3:GetObject",

          "s3:PutObject",

          "s3:ListBucket"

        ]

        Resource = [

          aws_s3_bucket.profile_images.arn,

          "${aws_s3_bucket.profile_images.arn}/*"

        ]

      }

    ]

  })
}
resource "aws_iam_role_policy_attachment" "profile_app_policy_attachment" {

  role = aws_iam_role.profile_app_role.name

  policy_arn = aws_iam_policy.profile_app_s3_policy.arn
}
resource "aws_vpc" "main_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "profile-app-vpc"
  }
}
resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.main_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  tags = {
    Name = "profile-app-public-subnet"
  }
}
resource "aws_subnet" "private_subnet" {

  vpc_id = aws_vpc.main_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1b"

  tags = {
    Name = "profile-app-private-subnet"
  }
}
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "profile-app-igw"
  }
}
resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "profile-app-public-rt"
  }
}
resource "aws_route_table_association" "public_subnet_association" {

  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_security_group" "web_sg" {

  name        = "profile-app-web-sg"
  description = "Security Group for Profile App"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Node App"

    from_port = 3000
    to_port   = 3000

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "profile-app-web-sg"
  }
}
resource "aws_instance" "profile_app_server" {

  ami = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  key_name = "profile_app_key"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.profile_app_profile.name

  user_data = file("${path.module}/../scripts/user-data.sh")

  associate_public_ip_address = true

  tags = {
    Name = "profile-app-server"
  }
}