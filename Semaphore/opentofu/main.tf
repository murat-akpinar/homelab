terraform {
    required_providers {
        proxmox = {
            source = "registry.terraform.io/bpg/proxmox"
            version = "0.60.1"
        }
    }
}

provider "proxmox" {
    endpoint = "https://192.168.1.10:8006" # Proxmox IP
    insecure = true
    username = "root@pam"
    password = "PASSWORD" # Promox root pasword
}

# Ubuntu VM 1
resource "proxmox_virtual_environment_vm" "ubuntu_vm_1" {
    name = "ubuntu-vm-1" # Hostname 
    node_name = "HomeLab" # Proxmox HomeLab name
    keyboard_layout = "en-us"

    cpu {
        cores = 2
        sockets = 2
        type = "host"
        numa = true
    }

    memory {
        dedicated = 2048
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.12/24"
                gateway = "192.168.1.1"
            }
        }       
        user_account {
            username = "ubuntu" # Username
            password = "ubuntu" # Password
            keys = [ "ssh-key" ] # SSH key
        }
    }

    disk {
        datastore_id = "local-lvm"
        file_id = proxmox_virtual_environment_file.ubuntu_cloud_image.id
        interface = "virtio0"
        iothread = true
        discard = "on"
        size = 96 # Disk Size GB
    }

    network_device {
        bridge = "vmbr0"
    }  
}
# Ubuntu VM 1

# Ubuntu VM 2
resource "proxmox_virtual_environment_vm" "ubuntu_vm_2" {
    name = "ubuntu-vm-2" # Hostname 
    node_name = "HomeLab" # Proxmox HomeLab name
#   vm_id = 260
    keyboard_layout = "en-us"

    cpu {
        cores = 2
        sockets = 2
        type = "host"
        numa = true
    }

    memory {
        dedicated = 2048
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.13/24"
                gateway = "192.168.1.1"
            }
        }       
        user_account {
            username = "ubuntu" # Username
            password = "ubuntu" # Password
            keys = [ "ssh-key" ] # SSH key
        }
    }

    disk {
        datastore_id = "local-lvm"
        file_id = proxmox_virtual_environment_file.ubuntu_cloud_image.id
        interface = "virtio0"
        iothread = true
        discard = "on"
        size = 96 # Disk Size GB
    }

    network_device {
        bridge = "vmbr0"
    }  
}
# Ubuntu VM 2

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
    content_type = "iso"
    datastore_id = "local"
    node_name = "HomeLab" # Proxmox HomeLab name
    source_file {        
        path = "iso/jammy-server-cloudimg-amd64.img"
        # https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
    }
}