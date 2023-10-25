
resource "aws_instance" "web-server" {
  ami                     = "ami-05ee09b16a3aaa2fd" # Debian 12 (HVM), SSD Volume Type, x86  eu cent
  instance_type           = "t3.micro"
  key_name                = "webserver"

  vpc_security_group_ids = [var.webhost_sg_id]
  subnet_id = var.pub_snet_1_id

  connection {
    type     = "ssh"
    user     = "admin"
    #private_key = file("webserver.pem")
    private_key = var.ec2_pem
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt update -y",
        "sudo apt install apache2 -y",
        "sudo apt install git -y",
        "sudo apt-get install php-mysql -y",
        "sudo apt -y install php php-common",
        "sudo apt-get -y install binutils",
        "git clone https://github.com/aws/efs-utils",
        "cd efs-utils",
        "./build-deb.sh",
        "sudo apt-get -y install ./build/amazon-efs-utils*deb",
        "cd ..",
        "sudo mount -t efs -o tls ${var.efs_dns}:/ /var/www/html",
        "echo \"${var.efs_dns}:/ /var/www/html efs _netdev,noresvport,tls 0 0\" | sudo tee -a /etc/fstab",
        "git clone https://github.com/shekeriev/bgapp",
        "sudo cp ~/bgapp/web/* /var/www/html",
        "sudo apt install default-mysql-client -y",
        "mysql -h ${var.rds_address} -u admin --password=${var.db_password} < ./bgapp/db/db_setup.sql",
        "sudo sed -i 's/db/${var.rds_address}/g' /var/www/html/config.php",
    ]
  }
  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "web-server-2" {
  ami                     = "ami-05ee09b16a3aaa2fd" # Debian 12 (HVM), SSD Volume Type, x86  eu cent
  instance_type           = "t3.micro"
  key_name                = "webserver"

  vpc_security_group_ids = [var.webhost_sg_id]
  subnet_id = var.pub_snet_2_id
  user_data = "${file("init.sh")}"
  tags = {
    Name = "web-server"
  }
   depends_on = [aws_instance.web-server]

}
