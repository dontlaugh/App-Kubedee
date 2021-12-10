unit class App::Kubedee:ver<1.0.0>;


has $.state-dir;
has $.config-dir;
has $.cache-dir;
has $.cluster-name;
has $.cert-dir;

method new(Str $cluster-name, Str :$state-dir = "{%*ENV{'HOME'}}/.local/share/kubedee", Str :$config-dir = "{%*ENV{'HOME'}}/.config/kubedee") {

    my $cache-dir = "{$state-dir}/cache";
    my $cert-dir = "{$state-dir}/clusters/{$cluster-name}/certificates";
    self.bless(:$cluster-name, :$state-dir, :$config-dir, :$cache-dir, :$cert-dir);
}

method init-dirs {
    # make dirs;
    mkdir $!state-dir;
    mkdir $!config-dir;
    mkdir $!cache-dir;
    # make cluster-specific subdirectories
    mkdir "{$!state-dir}/clusters/{$!cluster-name}/certificates";
}

method prune-old-caches(::?CLASS:U $kd) {
    # ~/.local/share/kubedee/cache/v0.7.0-67-g40e761a-dirty
    my @dirs = dir $!cache-dir;
    for @dirs -> $d {
        say "pruning dir $d";
        rmdir $d;
    }
}

method launch-etcd {
    my $image = 'kubedee-etcd';
    my $lxd = App::LXD.new;
    $lxd.launch("kubedee-{$!cluster-name}-etcd", $image);
}

method configure-etcd {
    # wait for container to be up
    # get etcd ip addr, create certificate (how?)
    my $cfssl = App::CFSSL.new: $!cert-dir;
    my $cn = 'etcd';
    my $O = 'etcd';
    my $OU = 'kubedee';
    my $profile = 'kubernetes';
    my $ip = 'get-it-somehow';
    $cfssl.create-certificate: 'ca-etcd', $cn, $O, $OU, $profile, "-hostnames={$ip},127.0.0.1";

    # our etcd container name; we'll only have one etcd container
    my $container = "kubedee-{$!cluster-name}-etcd";

    # block until etcd is running
    my $lxd = App::LXD.new;
    my $status = $lxd.container-status($container);
    until $status eq 'Running' {
        $status = $lxd.container-status($container);
        say "Waiting for $container; status: $status";
        sleep 1;
    }

    # push certs 
    # lxc file push -p "${kubedee_dir}/clusters/${cluster_name}/certificates/"{etcd.pem,etcd-key.pem,ca-etcd.pem} "${container_name}/etc/etcd/"
    run 'lxc', 'file', 'push', '-p', $!cert-dir.IO.add('etcd.pem'), "{$container}/etc/etcd/";
    run 'lxc', 'file', 'push', '-p', $!cert-dir.IO.add('etcd-key.pem'), "{$container}/etc/etcd/";
    run 'lxc', 'file', 'push', '-p', $!cert-dir.IO.add('ca-etcd.pem'), "{$container}/etc/etcd/";

    # write the systemd EnvironmentFile for etcd (location: /etc/etcd/env)
    run 'lxc', 'exec', $container, '--', 'sh', '-c', "echo ETCD_IP={$ip} > /etc/etcd/env";
    run 'lxc', 'exec', $container, '--', 'sh', '-c', "echo CONTAINER_NAME={$container} >> /etc/etcd/env";

    # systemctl daemon-reload, enable, start etcd
    run 'lxc', 'exec', $container, '--', 'systemctl', 'daemon-reload';
    run 'lxc', 'exec', $container, '--', 'systemctl', 'enable', '--now', '-q', 'etcd';

      # CREATE CERT

      #    cat <<EOF | cfssl gencert -ca=ca-etcd.pem -ca-key=ca-etcd-key.pem -config=ca-config.json -profile=kubernetes -hostname="${ip},127.0.0.1" - | cfssljson -bare etcd
      #{
      #  "CN": "etcd",
      #  "key": {
      #    "algo": "rsa",
      #    "size": 2048
      #  },
      #  "names": [
      #    {
      #      "C": "DE",
      #      "L": "Berlin",
      #      "O": "etcd",
      #      "OU": "kubedee",
      #      "ST": "Berlin"
      #    }
      #  ]
      #}
      #EOF
}

method launch-controller {
    my $image = 'kubedee-controller';
    my $lxd = App::LXD.new;
    $lxd.launch("kubedee-{$!cluster-name}-controller", $image);
}

method launch-worker {
    my $image = 'kubedee-worker';
    my $lxd = App::LXD.new;
    $lxd.launch("kubedee-{$!cluster-name}-worker", $image);
}

method smoke-test(::?CLASS:U $kd) {
}

method configure-worker(::?CLASS:U $kd) {
}

method configure-controller(::?CLASS:U $kd) {
}



method apiserver-wait-running(::?CLASS:U $kd) {
}

method container-wait-running(::?CLASS:U $kd) {
}