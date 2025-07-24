###
# Creates the VM used to deploy grafana, prometheus and alertmanager
###

# ami to use -> debian 12
data "aws_ami" "debian" {
  count = var.vm_ami != "" ? 0 : 1
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["136693071363"] # Debian
}

# vm instance
resource "aws_instance" "vm" {
  ami                  = var.vm_ami != "" ? var.vm_ami :data.aws_ami.debian[0].id
  iam_instance_profile = aws_iam_instance_profile.vm.name
  instance_type        = var.vm_size
  key_name             = local.name_prefix

  user_data_base64 = base64encode(templatefile("${path.module}/userdata.sh.tpl", {}))

  vpc_security_group_ids = [aws_security_group.vm.id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size           = var.os_disk_size
    volume_type           = var.os_disk_type
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
