vpc_cidr                 = "10.124.0.0/16"
key_name                 = "ant-terransible-key"
public_key_path          = "~/.ssh/ant-terransible.pub"
main_instance_count      = 2
shared_credentials_files = ["~/.aws/credentials"]
profile_name             = "ant-terransible"