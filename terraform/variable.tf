variable "region" {
  description = "north virginia region"
}

variable "az" {
  description = "Avilability zone of the public subnet"
}

variable "vpc_cidr" {
  description = "Vpc cidr"
}

variable "public_subnet_cidr" {
  description = "Public subnet cidr"
}

variable "my_ip" {
  description = "My host ip"
}

variable "default_ip" {
  description = "default ip"
}

variable "key_pair" {
  description = "The key used to access the instance using port 22"
}

variable "instance_type" {
  description = "Instance type"
}

variable "volume_name" {
  description = "Root device name"
}

variable "snapshot_id" {
  description = "Created for ami-096a578e6fb507c1a"
}