# Provider Configuration
# Specifies the AWS provider and region for Terraform to manage resources in.
provider "aws" {
  region = "us-east-1"
}

# WordPress EC2 Instance
resource "aws_instance" "wordpress_ec2" {
  ami                    = data.aws_ami.amazon_linux_2023.id # Use the AMI we filtered above
  instance_type          = "t2.micro"                        # Free tier eligible instance type
  subnet_id              = aws_subnet.public_subnet.id       # Place in the public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]    # Attach the EC2 security group
  key_name               = var.aws_key                       # Replace with your SSH key pair name

  # TODO: Pass in the 4 variables to the user data script
  user_data = templatefile("${path.module}/wp_rds_install.tpl", {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_host     = aws_db_instance.wordpress_db.address
  })

  tags = {
    Name = "WordPress EC2 Instance"
  }
}
