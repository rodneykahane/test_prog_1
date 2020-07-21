provider "aws" {
  region = "us-east-1"
}


variable "busybox_port"{
  description = "port used to connect to busybox server"
  type = number
  default = 8080
}

resource "aws_instance" "example" {
  ami                     = "ami-0ac80df6eff0e70b5"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              ls -l > index.html
              nohup busybox httpd -f -p ${var.busybox_port} &
              EOF

  tags = {

    Name = "terraform-example"
  }

} #end "aws_instance" "example"

resource "aws_security_group" "instance" {

  name = "terraform-example-instance"

  ingress {
    from_port   = var.busybox_port
    to_port     = var.busybox_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }   
} #end resource "aws_security_group" "instance"