variable "root_authorized_keys" {
  type    = string
}

variable "packages" {
  type    = string
  default = "vim net-tools mdadm ipset less lshw ethtool curl ca-certificates rsync"
}

variable "build_mem" {
  type    = string
  default = 1024
}

variable "vm_mem" {
  type    = string
  default = "3G"
}

variable "boot_wait" {
  type    = string
  default = "3s"
}

variable "bundle_iso" {
  type    = string
  default = "false"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "country" {
  type    = string
  default = "US"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "description" {
  type    = string
  default = "Base box for x86_64 Debian Buster 9.x"
}

variable "disk_size" {
  type    = string
  default = "30000"
}

variable "domain" {
  type    = string
  default = ""
}

variable "headless" {
  type    = string
  default = "true"
}

variable "host_port_max" {
  type    = string
  default = "4444"
}

variable "host_port_min" {
  type    = string
  default = "2222"
}

variable "http_port_max" {
  type    = string
  default = "9000"
}

variable "http_port_min" {
  type    = string
  default = "8000"
}

variable "iso_checksum" {
  type    = string
  default = "sha512:f4f7de1665cdcd00b2e526da6876f3e06a37da3549e9f880602f64407f602983a571c142eb0de0eacfc9c1d0f534e9339cdce04eb9daddc6ddfa8cf34853beed"
}

variable "iso_file" {
  type    = string
  default = "debian-12.8.0-amd64-netinst.iso"
}

variable "iso_mirror" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd"
}

variable "keyboard" {
  type    = string
  default = "us"
}

variable "language" {
  type    = string
  default = "en"
}

variable "locale" {
  type    = string
  default = "en_US.UTF-8"
}

variable "mirror" {
  type    = string
  default = "deb.debian.org"
}

variable "packer_cache_dir" {
  type    = string
  default = "${env("PACKER_CACHE_DIR")}"
}

variable "preseed_file" {
  type    = string
  default = "base.preseed"
}

variable "qemu_binary" {
  type    = string
  default = "qemu-system-x86_64"
}

variable "shutdown_timeout" {
  type    = string
  default = "5m"
}

variable "ssh_agent_auth" {
  type    = string
  default = "false"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_disable_agent_forwarding" {
  type    = string
  default = "false"
}

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "Debian"
}

variable "ssh_handshake_attempts" {
  type    = string
  default = "10"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "5s"
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_pty" {
  type    = string
  default = "false"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "debian"
}

variable "start_retry_timeout" {
  type    = string
  default = "5m"
}

variable "system_clock_in_utc" {
  type    = string
  default = "true"
}

variable "timezone" {
  type    = string
  default = "UTC"
}

variable "hostname" {
  type    = string
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "127.0.0.1"
}

variable "vnc_vrdp_port_max" {
  type    = string
  default = "6000"
}

variable "vnc_vrdp_port_min" {
  type    = string
  default = "5900"
}

variable "image_format" {
  type    = string
  default = "qcow2"
}

variable "net_device" {
  type    = string
  default = "e1000e"
}
