module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  ami                         = "ami-022daa15b37b5e55d"
  instance_type               = "t2.medium"
  key_name                    = "tamir-key"
  monitoring                  = true
  subnet_id                   = element(var.vpc_public_subnets, 0)
  user_data                   = file("${var.scripts_dir}/gh-runner-init.sh")
  disable_api_termination     = false
  vpc_security_group_ids      = [
        aws_security_group.aws_ec2_sg.id
      ]

  root_block_device = [
    {
      volume_size             = 30
      volume_type             = "gp2"
      delete_on_termination   = true
    },
  ]

  tags = {
    Name = "tamir-gh-runner-tf"
  }
}

resource "aws_eip" "gh_runner" {
  instance = module.ec2-instance.id
  tags = {
    "Name" = "tamir-gh-runner-eip-tf"
  }
}

resource "aws_security_group" "aws_ec2_sg" {
  name        = "tamir-gh-runner-sg-tf"
  description = "Allow traffic to Github server"
  vpc_id      = var.vpc_id

  egress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "ICMP from VPC"
    from_port        = "8"
    to_port          = "0"
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ICMP to VPC"
    from_port        = "8"
    to_port          = "0"
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH to VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP to VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Github Server to VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tamir-gh-runner-sg-tf"
  }
}
