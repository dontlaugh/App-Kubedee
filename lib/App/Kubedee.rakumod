unit class App::Kubedee:ver<1.0.0>;


has $.dir;
has $.config-dir;
has $.cache-dir;
has $.cluster-name;

method init-dirs {
    # make dirs;
    mkdir $!dir;
    mkdir $!config-dir;
    mkdir $!cache-dir;
    # make cluster-specific subdirectories
    mkdir "{$!dir}/clusters/{$!cluster-name}/certificates";
}

method cert-dir(--> Str) {
    "{$!dir}/clusters/{$!cluster-name}/certificates";
}

method init-lxd-resources {
    # create network

    say "FIXME: skipping create network";
    # has max 15 chars!
    #LXD.create-network: "kubedee-{$!cluster-name}";
    # create storage pool
    # TODO: just use default for now but allow this

    # create base image (kubedee::prepare_container_image)
    # in LXD this is just a few packages: socat, libgpgme11 kitty-terminfo
}

# Kubedee
# LXD high level routines
# create certs, kubeconfig, lxc device add, systemd units

method prepare-container-image(::?CLASS:U $kd) {
    App::LXD.image-list

}

method fetch-etcd(::?CLASS:U $kd) {

}

method fetch-cni-plugins(::?CLASS:U $kd) {

}

method fetch-crio(::?CLASS:U $kd) {
}

method fetch-k8s(::?CLASS:U $kd) {
    # fetch kube-apiserver,kube-controller-manager,kubectl,kubelet,kube-proxy,kube-scheduler
}

method fetch-runc(::?CLASS:U $kd) {
}

method log(::?CLASS:U $kd) {
}

method prune-old-caches(::?CLASS:U $kd) {
    # ~/.local/share/kubedee/cache/v0.7.0-67-g40e761a-dirty
    my @dirs = dir $!cache-dir;
    for @dirs -> $d {
        say "pruning dir $d";
        rmdir $d;
    }
}

method smoke-test(::?CLASS:U $kd) {
}

method configure-worker(::?CLASS:U $kd) {
}

method configure-controller(::?CLASS:U $kd) {
}

method configure-etcd(::?CLASS:U $kd) {
}

method apiserver-wait-running(::?CLASS:U $kd) {
}

method container-wait-running(::?CLASS:U $kd) {
}