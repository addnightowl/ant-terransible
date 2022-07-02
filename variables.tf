# --- lunx-terransible/variables.tf ---

# var.vpc_cidr
variable "vpc_cidr" {
  type    = string
  default = "10.123.0.0/16"
}

# var.access_ip
variable "access_ip" {
  type    = string
  default = "73.115.239.96/32"
}

# var.cloud9_ip
variable "cloud9_ip" {
  type    = string
  default = "52.21.53.148/32"
}

# var.main_instance_type
variable "main_instance_type" {
  type    = string
  default = "t2.micro"
}

# var.main_vol_size
variable "main_vol_size" {
  type    = number
  default = 8
}

# var.main_instance_count
variable "main_instance_count" {
  type    = number
  default = 1
}

# var.key_name
variable "key_name" {
  type = string
}

# var.public_key_path
variable "public_key_path" {
  type = string
}

# var.shared_credentials_files
variable "shared_credentials_files" {
  type = list(any)
}
