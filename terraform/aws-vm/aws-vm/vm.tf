###
# Creates the VM used to deploy grafana, prometheus and alertmanager
# Creates also the associated keypair (optional)
###

## create keypair
resource "aws_key_pair" "vm" {
  key_name   = "${var.organization}-vm-monitoring-${var.env}"
  public_key = var.ssh_public_key
}

# ami to use -> debian 10
data "aws_ami" "debian" {
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
  ami = data.aws_ami.debian.id
  iam_instance_profile = aws_iam_instance_profile.vm.name
  instance_type        = var.vm_size
  key_name             = "${var.organization}-vm-monitoring-${var.env}"

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
