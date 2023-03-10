
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
  disk_image              = true
  disk_size               = "10G"
  disk_interface          = "ide"
  display                 = "gtk"
  headless                = true
  iso_checksum            = "none"
  iso_url                 = "${var.iso_url}"
  memory                  = 1024
  net_device              = "e1000"
  output_directory        = "${local.work_dir}"
  shutdown_command        = "halt -p"
  ssh_keep_alive_interval = "5s"
  ssh_password            = "root"
  ssh_read_write_timeout  = "15s"
  ssh_timeout             = "60s"
  ssh_username            = "root"
  vm_name                 = "bastion"
}

build {
  sources = ["source.qemu.bastion"]

  provisioner "ansible" {
    playbook_file = "${path.root}/playbook.yml"
    user="root"
    extra_arguments = [ "-vvvvv"]
    //ansible_ssh_extra_args = [ "-oControlPersist=30m" ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "${var.output_dir}/${var.vm_name}"
  }
}
