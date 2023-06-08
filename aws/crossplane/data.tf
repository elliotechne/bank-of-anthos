data "aws_ami" "primary" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  owners = [var.ami_owner]
}

