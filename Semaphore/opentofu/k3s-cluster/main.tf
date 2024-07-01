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
    password = "admin" # Promox root pasword
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
    content_type = "iso"
    datastore_id = "local"
    node_name = "HomeLab" # Proxmox HomeLab name
    source_file {
        path = "iso/jammy-server-cloudimg-amd64.img"
        # https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
    }
}

# master-1
resource "proxmox_virtual_environment_vm" "ubuntu_vm_101" {
    name = "master-1" # Hostname
    node_name = "HomeLab" # Proxmox HomeLab name
    keyboard_layout = "en-us"
    vm_id = 101

    cpu {
        cores = 1
        sockets = 1
        type = "host"
        numa = true
    }

    memory {
        dedicated = 1024
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.11/24"
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
        size = 100 # Disk Size GB
    }

    network_device {
        bridge = "vmbr0"
    }
}
# master-1

# master-2
resource "proxmox_virtual_environment_vm" "ubuntu_vm_102" {
    name = "master-2" # Hostname
    node_name = "HomeLab" # Proxmox HomeLab name
    vm_id = 102
    keyboard_layout = "en-us"

    cpu {
        cores = 1
        sockets = 1
        type = "host"
        numa = true
    }

    memory {
        dedicated = 1024
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
        size = 100 # Disk Size GB
    }

    network_device {
        bridge = "vmbr0"
    }
}
# master-2

# master-3
resource "proxmox_virtual_environment_vm" "ubuntu_vm_103" {
    name = "master-3" # Hostname
    node_name = "HomeLab" # Proxmox HomeLab name
    vm_id = 103
    keyboard_layout = "en-us"

    cpu {
        cores = 1
        sockets = 1
        type = "host"
        numa = true
    }

    memory {
        dedicated = 1024
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
        size = 100 # Disk Size GB
    }

    network_device {
        bridge = "vmbr0"
    }
}
# master-3