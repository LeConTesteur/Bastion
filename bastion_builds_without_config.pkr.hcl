
variable "disk_checksum" {
  type    = string
  default = "sha256:289720743885b72b579d9926e24d07d5838fdf985569ec7f100a4ceef20dce5c"
}


locals {
  base_output_directory = "output/"
  output_directory      = "${local.base_output_directory}/output-${local.vm_name}_without_config"
  vm_name               = "bastion"
  #utm_url = "https://cdimage.debian.org/cdimage/release/11.2.0/amd64/iso-dvd/debian-11.4.0-amd64-DVD-1.iso"
  utm_url = "/home/qa/Téléchargements/debian-11.2.0-amd64-DVD-1.iso" //TODO CHANGE DVD
}

source "qemu" "bastion" {
  accelerator             = "kvm"
  boot_wait               = "2s"
  communicator            = "ssh"
  cpus                    = 1
  disk_image              = false
  disk_size               = "10G"
  disk_interface          = "ide"
  display                 = "gtk"
  headless                = false
  iso_checksum            = "none"
  iso_url                 = "${local.utm_url}"
  memory                  = 1024
  net_device              = "e1000"
  output_directory        = "${local.output_directory}"
  shutdown_command        = "halt -p"
  ssh_keep_alive_interval = "15s"
  ssh_password            = "root"
  ssh_read_write_timeout  = "5m"
  ssh_timeout             = "430s"
  ssh_username            = "root"
  vm_name                 = "${local.vm_name}"
  http_directory = "${path.root}"
  boot_command = [
    "<esc><wait>",
    "install <wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
    "debian-installer=fr_FR.UTF-8 <wait>",
    "auto <wait>",
    "locale=fr_FR.UTF-8 <wait>",
    "kbd-chooser/method=fr <wait>",
    "keyboard-configuration/xkb-keymap=fr <wait>",
    "netcfg/get_hostname={{ .Name }} <wait>",
    "netcfg/get_domain=test.smc.lyon.labo.int <wait>",
    "fb=false <wait>",
    "debconf/frontend=noninteractive <wait>",
    "<enter><wait>"
  ]
}

build {
  sources = ["source.qemu.bastion"]

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "output/packer_${local.vm_name}_without_config.box"
  }
}
