
resource "aws_instance" "web-server-1a" {
  ami                     = "ami-05ee09b16a3aaa2fd" # Debian 12 (HVM), SSD Volume Type, x86  eu cent
  instance_type           = "t3.micro"
  key_name                = "webserver"

  vpc_security_group_ids = [var.webhost_sg_id]
  subnet_id = var.pub_snet_1_id
  user_data = templatefile("${path.module}/init.sh.tftpl", {efs_dns = var.efs_dns})
  tags = {
    Name = "web-server"
  }
}


resource "aws_instance" "web-server-1b" {
  ami                     = "ami-05ee09b16a3aaa2fd" # Debian 12 (HVM), SSD Volume Type, x86  eu cent
  instance_type           = "t3.micro"
  key_name                = "webserver"
  vpc_security_group_ids = [var.webhost_sg_id]
  subnet_id = var.pub_snet_2_id
  user_data = templatefile("${path.module}/init.sh.tftpl", {efs_dns = var.efs_dns})
  tags = {
    Name = "web-server"
  }
   depends_on = [aws_instance.web-server-1a]

}

