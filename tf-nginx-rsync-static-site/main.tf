variable "allowed_ports" {
  type = list(number)
  default = [80, 443, 22]
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
}

resource "aws_key_pair" "key_pair" {
  key_name   = "static-website-key"
  public_key = file("~/.ssh/key_pair.pub")
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web_server_sg"
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}

