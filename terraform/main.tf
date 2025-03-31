resource "aws_instance" "vm" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.kubernetes_vm_sg.name]

  tags = {
    Name = "kubernetes-vm"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.vm.id
  allocation_id = aws_eip.eip.id
}

output "vm_ip" {
  value = aws_instance.vm.public_ip
}

resource "null_resource" "provision" {
  depends_on = [aws_eip_association.eip_assoc]

  provisioner "local-exec" {
    command = <<EOT
      echo '[vm]' > inventory.ini
      echo '${aws_eip.eip.public_ip}' >> inventory.ini
      sleep 30
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini -u ubuntu -e "vm_user=${var.vm_user} public_ip=${aws_eip.eip.public_ip}" install_kube.yaml
      scp -o StrictHostKeyChecking=no -i ${var.key_path} ${var.vm_user}@${aws_eip.eip.public_ip}:/home/${var.vm_user}/.kube/config ./admin.conf
    EOT
  }
}