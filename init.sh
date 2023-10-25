#!/bin/bash
apt update -y
apt install apache2 -y
apt install git -y
apt-get install php-mysql -y
apt -y install php php-common
apt-get -y install binutils
git clone https://github.com/aws/efs-utils
cd efs-uti
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
cd ..
sudo mount -t efs -o tls ${var.efs_dns}:/ /var/www/html
echo \"${var.efs_dns}:/ /var/www/html efs _netdev,noresvport,tls 0 0\" | sudo tee -a /etc/fstab