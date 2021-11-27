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

  # etcd.service - initcluster container name, client urls
  provisioner "file" {
    only = ["lxd.kubedee-etcd"]
    content = templatefile("./templates/etcd.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/etcd.service"
  }

  # kube-proxy.service - cluster-cidr=10.200.0.0/16
  provisioner "file" {
    only = ["lxd.kubedee-controller", "lxd.kubedee-worker"]
    content = templatefile("./templates/kube-proxy.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/kube-proxy.service"
  }

  provisioner "file" {
    only = ["lxd.kubedee-controller", "lxd.kubedee-worker"]
    content = templatefile("./templates/kubelet.service.pkrtpl.hcl", 
        {})
    destination = "/etc/systemd/system/kubelet.service"
  }

  # crio.service
  provisioner "file" {
    only = ["lxd.kubedee-controller", "lxd.kubedee-worker"]
    content = templatefile("./templates/crio.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/crio.service"
  }

  #kube-scheduler.service 
  provisioner "file" {
    only = ["lxd.kubedee-controller"]
    content = templatefile("./templates/kube-scheduler.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/kube-scheduler.service"
  }

  # kube-apiserver.service - admission-plugins, etcdip:2379, 
  #    service-cluster-ip-range, node-port-range,
  provisioner "file" {
    only = ["lxd.kubedee-controller"]
    content = templatefile("./templates/kube-apiserver.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/kube-apiserver.service"
  }

  # kube-controller-manager.service - cluster-cidr, service-cluster-ip-range
  provisioner "file" {
    only = ["lxd.kubedee-controller"]
    content = templatefile("./templates/kube-controller-manager.service.pkrtpl.hcl",
        {})
    destination = "/etc/systemd/system/kube-controller-manager.service"
  }

}

