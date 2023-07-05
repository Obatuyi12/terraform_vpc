variable "region" {
  default     = "eu-west-2"
  description = "AWS Region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "public_subnet_1_cidr" {
  default     = "10.0.1.0/24"
  description = "Public Subnet 1 cidr"
}

variable "public_subnet_2_cidr" {
  default     = "10.0.2.0/24"
  description = "Public Subnet 2 cidr"
}

variable "private_subnet_1_cidr" {
  default     = "10.0.3.0/24"
  description = "Private Subnet 1 cidr"
}

variable "private_subnet_2_cidr" {
  default     = "10.0.4.0/24"
  description = "Private Subnet 2 cidr"
}



