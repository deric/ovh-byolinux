# ovh-byolinux
Bring Your Own Linux template


## Requirements

 - [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
 - QEMU (optional)

On Debian:
```
apt install qemu-utils qemu-system-x86 bridge-utils libvirt-daemon libvirt-daemon-system
```

install packer:
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install packer
```

## Usage

Fill required variable into e.g. `example.pkrvars.hcl`:
```
cat <<EOF > example.pkrvars.hcl
hostname = "host.example.com"
ssh_password = ""
root_authorized_keys = ""
EOF
```
See `variables.pkr.hcl` for more information.

On the first initialize plugins
```
packer init debian/12/base.pkr.hcl
```

then run build with provided `var-file`
```
packer build -var-file=example.pkrvars.hcl debian/12
```

## How does this work?

 - Fetch Debian `iso_file` from `iso_mirror`, see `variables.pkr.hcl`
 - Debian installer will be executed in QEMU VM
 - You can check installation progress via VNC, e.g `vnc://127.0.0.1:5901`
 - `12/base.preseed` file is used to automatically answer all questions
 - After finising basic Debian installation, custom scripts can be executed over `ssh`, see `provisioner "shell"`
 - If the installation is successful image disk will be converted in `qcow2` image
 - You can check the the final image with e.g. `qemu-system-x86_64 -m 2G -enable-kvm -boot menu=on -device e1000e -drive file=build/2024-10-06_13-14/host.example.com.qcow2`
 - Use `debian` user and password you've configured as `ssh_password`
 - Final image contains `/root/.ovh/make_image_bootable.sh` script that should reconfigure `grub` (see `scripts/make_image_bootable.sh`)

 ## Notes

 - Don't try to modify partitioning in preseed file, OVH installer will create partitions (data from provided image are copied)
 - If the installed server is unreachable, you might be missing network card drivers
