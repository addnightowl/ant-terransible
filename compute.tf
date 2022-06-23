# --- lunx-terransible/compute.tf ---

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # * = latest
  }
}

resource "random_id" "ant_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_key_pair" "ant_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "ant_main" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.ant_auth.id
  vpc_security_group_ids = [aws_security_group.ant_sg.id]
  subnet_id              = aws_subnet.ant_public_subnet[count.index].id
  # user_data              = templatefile("./main-userdata.tpl", { new_hostname = "ant-main-instance-${random_id.ant_node_id[count.index].dec}" })
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "ant-main-instance-${random_id.ant_node_id[count.index].dec}"
  }

    # # provisioners use "-" not "_".
    # provisioner "local-exec" {
    #   command = "printf '\n${self.public_ip}' >> aws_hosts"
    #   # command = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region us-west-1"
    # }
    # # you have to destroy everything for a destroy provisioner to work.
    # provisioner "local-exec" {
    #   when    = destroy
    #   command = "sed -i '/^[0-9]/d' aws_hosts" #any line that '/^(starts with)[0-9](process that line)/d(delete that line)' (filename)
    # }
}

# run tf init to initialize the null_resource
# resource "null_resource" "grafana_update" {
#   count = var.main_instance_count
#   provisioner "remote-exec" {
#     inline = ["sudo apt upgrade -y grafana && touch upgrade.log && echo 'I updated Grafana.' >> upgrade.log"]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("/home/ubuntu/.ssh/antkey")
#       host        = aws_instance.ant_main[count.index].public_ip
#     }
#   }
# }

# we only want ansible to run once after ALL aws_instance(s) in ant_main are created, therefore use a null_resource
# resource "null_resource" "grafana_install" {
#   depends_on = [aws_instance.ant_main]
#   provisioner "local-exec" {
#     command = "ansible-playbook -i aws_hosts --key-file /home/ubuntu/.ssh/antkey playbooks/main-playbook.yml"
#   }
# }

output "grafana_access" {
  value = { for i in aws_instance.ant_main[*] : i.tags.Name => "${i.public_ip}:3000" }
}

output "instance_ips" {
  value = [for i in aws_instance.ant_main[*] : i.public_ip]
}

output "instance_ids" {
  value = [for i in aws_instance.ant_main[*] : i.id]
}