variable "iso_url" {
  type = string
}

variable "output_dir" {
  type = string
}

variable "vm_name" {
  type = string
  default = "bastion"
}

locals {
  work_dir = "${var.output_dir}/work-${var.vm_name}"
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
  iso_url                 = "${var.iso_url}"
  memory                  = 1024
  net_device              = "e1000"
  output_directory        = "${local.work_dir}"
  shutdown_command        = "halt -p"
  ssh_keep_alive_interval = "15s"
  ssh_password            = "root"
  ssh_read_write_timeout  = "5m"
  ssh_timeout             = "430s"
  ssh_username            = "root"
  vm_name                 = "bastion"
  http_directory = "${path.root}"
  boot_command = [
    "<esc><wait>",
    "install <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
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
    keep_input_artifact = false
    output              = "${var.output_dir}/${var.vm_name}"
  }
}
