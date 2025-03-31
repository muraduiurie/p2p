variable "ami" {
    description = "The AMI to use for the VM"
    type        = string
    default     = "ami-031e7dbab5571668f" # Ubuntu 22.04 LTS
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
    type        = string
    description = "The name of the EC2 key pair"
}

variable "profile" {
    type        = string
    description = "The name of the AWS profile to use"
    default     = "default"
}

variable "key_path" {
    type        = string
    description = "The path to the private key"
}

variable "vm_user" {
    type        = string
    description = "The username to use when connecting to the VM"
    default     = "ubuntu"
}

variable "region" {
    type        = string
    description = "The AWS region to use"
    default     = "eu-west-3"
}