resource "aws_efs_file_system" "web-efs" {
    tags = {
      Name = "web-efs"
    }
}

resource "aws_efs_mount_target" "web-efs-mount-1" {
   file_system_id  = aws_efs_file_system.web-efs.id
   subnet_id = aws_subnet.pub-snet-1.id
   security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "web-efs-mount-2" {
   file_system_id  = aws_efs_file_system.web-efs.id
   subnet_id = aws_subnet.pub-snet-2.id
   security_groups = [aws_security_group.efs_sg.id]
}



