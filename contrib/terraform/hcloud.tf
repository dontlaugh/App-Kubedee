variable "hcloud_token" {
  type = "string"
}

variable "hcloud_sshkeys" {
  type = "list"
}

provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_server" "test" {
  count = 1
  name = "kubedee.example.com"
  image = "ubuntu-18.04"
  ssh_keys = "${var.hcloud_sshkeys}"
  server_type = "cx21"
  datacenter = "fsn1-dc8"
  user_data = "${file("user-data.bash")}"

  provisioner "remote-exec" {
    inline = [
      "until test -f /var/lib/cloud/instance/boot-finished; do echo 'waiting for cloud-init to finish'; sleep 5; done",
      "mkdir -p /home/ubuntu/.ssh",
      "install /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys",
    ]

    connection {
      user = "root"
    }
  }

  connection {
    user = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/bin",
      "mkdir -p /home/ubuntu/kubedee",
    ]
  }

  provisioner "file" {
    source = "../../kubedee"
    destination = "/home/ubuntu/kubedee/kubedee"
  }
  provisioner "file" {
    source = "../../lib.bash"
    destination = "/home/ubuntu/kubedee/lib.bash"
  }
  provisioner "file" {
    source = "../../manifests"
    destination = "/home/ubuntu/kubedee/"
  }
  provisioner "file" {
    source = "../../scripts"
    destination = "/home/ubuntu/kubedee/"
  }

  provisioner "remote-exec" {
    inline = [
      # Raise conntrack hashsize to avoid fatal kube-proxy error:
      # [...]
      # Sep 06 19:46:37 kubedee-test-worker-5fe2ch kube-proxy[1213]: I0906 19:46:37.392376    1213 conntrack.go:83] Setting conntrack hashsize to 32768
      # Sep 06 19:46:37 kubedee-test-worker-5fe2ch kube-proxy[1213]: F0906 19:46:37.392425    1213 server.go:361] write /sys/module/nf_conntrack/parameters/hashsize: operation not supported
      "echo 65536 | sudo tee /sys/module/nf_conntrack/parameters/hashsize",

      # Setup kubedee
      "chmod +x kubedee/kubedee",
      "chmod +x kubedee/scripts/download-k8s-binaries",
      "ln -s /home/ubuntu/kubedee/kubedee bin/kubedee",

      # Create cluster
      "./kubedee/scripts/download-k8s-binaries v1.11.2 k8s-binaries",
      "./bin/kubedee up --apiserver-extra-hostnames ${hcloud_server.test.name} --bin-dir ./k8s-binaries/kubernetes/server/bin/ test",

      # Setup ingress
      "kubectl apply -f kubedee/manifests/ingress-nginx.yml",

      # Make ingress-nginx accessible
      "sudo iptables -t nat -A PREROUTING -p tcp -d ${hcloud_server.test.ipv4_address} --dport 80 -j DNAT --to-destination $(./bin/kubedee controller-ip test):80",
      "sudo iptables -t nat -A PREROUTING -p tcp -d ${hcloud_server.test.ipv4_address} --dport 443 -j DNAT --to-destination $(./bin/kubedee controller-ip test):443",

      # Make apiserver accessible
      "sudo iptables -t nat -A PREROUTING -p tcp -d ${hcloud_server.test.ipv4_address} --dport 6443 -j DNAT --to-destination $(./bin/kubedee controller-ip test):6443",
    ]
  }
}