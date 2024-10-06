packer {
  required_version = ">= 1.7.0, < 2.0.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0, < 2.0.0"
    }
  }
}

locals {
  output_directory = "build/${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
}

source "qemu" "debian" {
  accelerator = "kvm"
  boot_command = [
    "<wait><wait><wait><esc><wait><wait><wait>",
    "/install.amd/vmlinuz ",
    "initrd=/install.amd/initrd.gz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
    "hostname=${var.hostname} ",
    "domain=${var.domain} ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>"
  ]
  boot_wait            = var.boot_wait
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_cache           = "writeback"
  disk_compression     = true
  disk_discard         = "ignore"
  disk_image           = false
  disk_interface       = "virtio-scsi"
  disk_size            = var.disk_size
  format               = var.image_format
  headless             = var.headless
  host_port_max        = var.host_port_max
  host_port_min        = var.host_port_min
  http_content         = { "/${var.preseed_file}" = templatefile(var.preseed_file, { var = var }) }
  http_port_max        = var.http_port_max
  http_port_min        = var.http_port_min
  iso_checksum         = var.iso_checksum
  iso_skip_cache       = false
  iso_target_extension = "iso"
  iso_target_path      = "${regex_replace(var.packer_cache_dir, "^$", "/tmp")}/${var.iso_file}"
  iso_urls = [
    "${var.iso_mirror}/${var.iso_file}"
  ]
  machine_type = "pc"
  memory       = var.build_mem
  //net_device       = "virtio-net"
  // pure magic, should immitate common intel driver
  net_device = var.net_device
  //net_bridge       = "virbr0"
  output_directory             = local.output_directory
  qemu_binary                  = var.qemu_binary
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  shutdown_timeout             = var.shutdown_timeout
  skip_compaction              = false
  skip_nat_mapping             = false
  ssh_agent_auth               = var.ssh_agent_auth
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_password                 = var.ssh_password
  ssh_port                     = var.ssh_port
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = var.ssh_username
  use_default_display          = false
  vm_name                      = "${var.hostname}.${var.image_format}"
  vnc_bind_address             = var.vnc_vrdp_bind_address
  vnc_port_max                 = var.vnc_vrdp_port_max
  vnc_port_min                 = var.vnc_vrdp_port_min
}

build {
  sources = ["source.qemu.debian"]

  provisioner "file" {
    source      = "scripts/make_image_bootable.sh"
    destination = "/tmp/make_image_bootable.sh"
  }

  provisioner "shell" {
    binary = false
    # by default displays a "lecture" that goes to stderr
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} 2>/dev/null {{ .Path }}"
    expect_disconnect = false
    inline = [
      "echo '${var.ssh_username} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99-${var.ssh_username}",
      "chmod 0440 /etc/sudoers.d/99-${var.ssh_username}",
      "exit 0"
    ]
    inline_shebang      = "/bin/bash"
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    inline = [
      "sudo -S mv /tmp/make_image_bootable.sh /root/.ovh/ && sudo -S chmod -R +x /root/.ovh/",
      "sudo -S chown -R root:root /root/.ovh/",
      # copy root ssh key into user account
      "mkdir ~/.ssh && chmod 0700 ~/.ssh && echo '${var.root_authorized_keys}' >> ~/.ssh/authorized_keys",
      "chmod 0600 ~/.ssh/authorized_keys"
    ]
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output         = "${local.output_directory}/${var.hostname}.${var.image_format}.{{.ChecksumType}}"
  }

  post-processor "shell-local" {
    inline = ["echo \"Test final image e.g. with:\\nqemu-system-x86_64 -m ${var.vm_mem} -enable-kvm -boot menu=on -device ${var.net_device} -drive file=${local.output_directory}/${var.hostname}.${var.image_format}\""]
  }
}
