resource "aws_efs_file_system" "web-efs" {
    tags = {
      Name = "web-efs"
    }
}

resource "aws_efs_mount_target" "web-efs-mount-1" {
   file_system_id  = aws_efs_file_system.web-efs.id
   subnet_id = var.pub_snet_1_id 
   security_groups = [var.efs_sg_id]
}

resource "aws_efs_mount_target" "web-efs-mount-2" {
   file_system_id  = aws_efs_file_system.web-efs.id
   subnet_id = var.pub_snet_2_id 
   security_groups = [var.efs_sg_id]
}



