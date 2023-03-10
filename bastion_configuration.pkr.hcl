
variable "disk_checksum" {
  type    = string
  default = "sha256:289720743885b72b579d9926e24d07d5838fdf985569ec7f100a4ceef20dce5c"
}


locals {
  base_output_directory = "output/"
  output_directory      = "${local.base_output_directory}/output-${local.vm_name}"
  vm_name               = "bastion"
  #utm_url = "https://cdimage.debian.org/cdimage/release/11.2.0/amd64/iso-dvd/debian-11.4.0-amd64-DVD-1.iso"
  utm_url = "output/output-bastion_without_config/bastion-0" //TODO CHANGE DVD
}

source "qemu" "client" {
  accelerator             = "kvm"
  boot_wait               = "2s"
  communicator            = "ssh"
  cpus                    = 1
  disk_image              = true
  disk_size               = "10G"
  disk_interface          = "ide"
  display                 = "gtk"
  headless                = true
  iso_checksum            = "none"
  iso_url                 = "${local.utm_url}"
  memory                  = 1024
  net_device              = "e1000"
  output_directory        = "${local.output_directory}"
  shutdown_command        = "halt -p"
  ssh_keep_alive_interval = "5s"
  ssh_password            = "root"
  ssh_read_write_timeout  = "15s"
  ssh_timeout             = "60s"
  ssh_username            = "root"
  vm_name                 = "${local.vm_name}"
}

build {
  sources = ["source.qemu.client"]

  provisioner "ansible" {
    playbook_file = "${path.root}/playbook.yml"
    user="root"
    extra_arguments = [ "-vvvvv"]
    //ansible_ssh_extra_args = [ "-oControlPersist=30m" ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "output/packer_${local.vm_name}.box"
  }
}
