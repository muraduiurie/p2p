resource "aws_eip" "kube" {
  domain = "vpc"
}

resource "aws_eip_association" "kube" {
  instance_id   = aws_instance.kube.id
  allocation_id = aws_eip.kube.id
}

resource "aws_eip" "nfs" {
  domain = "vpc"
}

resource "aws_eip_association" "nfs" {
  instance_id   = aws_instance.nfs.id
  allocation_id = aws_eip.nfs.id
}