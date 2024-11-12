variable "allowed_ports" {
  type = list(number)
  default = [80, 443, 22]
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.web_server_sg.name]

  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/key_pair")
      host        = self.public_ip
      timeout     = "2m"
    }
    
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "timeout 30 sudo systemctl start nginx",
      "timeout 30 sudo systemctl status nginx",
      "echo 'Moving files...'",
      "cd /var/www/html",
      "mv dist/* . || echo 'Move failed'",
      "echo 'Files moved successfully'",
      "sudo systemctl stop nginx",
      "sudo systemctl start nginx",
      "sudo systemctl daemon-reload"
    ]
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "static-website-key"
  public_key = file("~/.ssh/key_pair.pub")
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web_server_sg"
  
  # Ingress rules
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rules
  dynamic "egress" {
    for_each = var.allowed_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}