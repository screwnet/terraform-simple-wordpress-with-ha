# This volume will store the  WordPress files for single mount point.
resource "aws_efs_file_system" "wp-filestore" {
  creation_token   = "wp-filestore"
  encrypted        = false
  performance_mode = "generalPurpose"
  tags             = var.tags
  throughput_mode  = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_90_DAYS"
  }
}

# EFS mount target for NFS
resource "aws_efs_mount_target" "wp-filestore-mount-1" {
  file_system_id  = aws_efs_file_system.wp-filestore.id
  subnet_id       = aws_subnet.bastion_subnet1.id
  security_groups = [aws_security_group.bastion_sg.id]
}

resource "aws_efs_mount_target" "wp-filestore-mount-2" {
  file_system_id  = aws_efs_file_system.wp-filestore.id
  subnet_id       = aws_subnet.bastion_subnet2.id
  security_groups = [aws_security_group.bastion_sg.id]
}
