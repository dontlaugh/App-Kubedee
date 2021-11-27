packer {
  required_plugins {
    lxd = {
      version = ">=1.0.0"
      source  = "github.com/hashicorp/lxd"
    }
  }
}


locals {
  ts                     = formatdate("YYYYMMDDhhmmss", timestamp())
}

source "lxd" "ubuntu_2004" {
  image = "images:ubuntu/20.04"
}


build {

  source "lxd.ubuntu_2004" {
    name           = "kubedee-etcd"
    output_image   = "kubedee-etcd"
    container_name = "kubedee-etcd-${local.ts}"
  }

  source "lxd.ubuntu_2004" {
    name           = "kubedee-controller"
    output_image   = "kubedee-controller"
    container_name = "kubedee-controller-${local.ts}"
  }

  source "lxd.ubuntu_2004" {
    name           = "kubedee-worker"
    output_image   = "kubedee-worker"
    container_name = "kubedee-worker-${local.ts}"
  }

  provisioner "shell" {
    inline = [
      "apt-get update -y",
      "apt-get install -y libgpgme11 kitty-terminfo htop jq socat curl",
      "rm -rf /var/cache/apt",
    ]
  }

  provisioner "file" {

  }

}
