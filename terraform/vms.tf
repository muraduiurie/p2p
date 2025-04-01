resource "aws_instance" "kube" {
  ami                         = var.ami
  instance_type               = var.kube_instance_type
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.kubernetes_vm_sg.name]

  tags = {
    Name = "kubernetes-vm"
    Type = "kubernetes"
  }
}

resource "aws_instance" "nfs" {
  ami                         = var.ami
  instance_type               = var.nfs_instance_type
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.nfs_vm_sg.name]

  tags = {
    Name = "nfs-vm"
    Type = "NFS"
  }

  depends_on = [aws_instance.kube]
}

output "kube_public_ip" {
  value = aws_instance.kube.public_ip
}

resource "null_resource" "provision_kube" {
  depends_on = [aws_eip_association.kube]

  provisioner "local-exec" {
    command = <<EOT
      echo '[vm]' > inventory_kube.ini
      echo '${aws_eip.kube.public_ip}' >> inventory_kube.ini
      sleep 30
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_kube.ini -u ubuntu -e "vm_user=${var.vm_user} public_ip=${aws_eip.kube.public_ip}" ../ansible/install_kube.yaml
      scp -o StrictHostKeyChecking=no -i ${var.key_path} ${var.vm_user}@${aws_eip.kube.public_ip}:/home/${var.vm_user}/.kube/config ./admin.conf
    EOT
  }
}

resource "null_resource" "provision_nfs" {
    depends_on = [aws_eip_association.nfs]

  provisioner "local-exec" {
    command = <<EOT
      echo '[vm]' > inventory_nfs.ini
      echo '${aws_eip.nfs.public_ip}' >> inventory_nfs.ini
      sleep 30
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_nfs.ini -u ubuntu -e "nfs_network=${aws_eip.kube.public_ip}/32" ../ansible/install_nfs.yaml
    EOT
  }
}