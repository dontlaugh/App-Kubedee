# cli help
# https://docs.raku.org/language/create-cli#sub_USAGE
use JSON::Fast;
use App::Kubedee;

my $kubedee_version = "1.0.0";
my $home = %*ENV{'HOME'};
my $kubedee-dir = "{$home}/.local/share/kubedee";
my $kubedee-config-dir = "{$home}/.config/kubedee";
my $kubedee-cache-dir = "{$kubedee-dir}/cache/{$kubedee_version}";
my $install_psps = False;


my %*SUB-MAIN-OPTS =
  :named-anywhere,
;

# CFSSL
class CFSsl {
    # $cert-dir holds our cluster certificates and cfssl configs
    #   $cert-dir/{ca.pem,ca-key.pem,ca-config.json,profile.k8s}
    has Str $!cert-dir;

    method create_certificate_admin(Str $cluster-name) {

    }
    method create_certificate_aggregation_client() {

    }
    method create_certificate_authority_aggregation() {

    }
    method create_certificate_authority_etcd() {

    }
    method create_certificate_authority_k8s() {

    }
    method create_certificate_etcd() {

    }
    method create_certificate_kube_controller_manager() {

    }
    method create_certificate_kubernetes() {

    }
    method create_certificate_kube_scheduler() {

    }
    method create_certificate_worker() {

    }

}


class Kubectl {
    method label_and_taint_controller(::CLASS:U $k) {

    }
    method label_worker(::CLASS:U $k) {

    }
    method deploy_core_dns(::CLASS:U $k) {

    }
    method deploy_flannel(::CLASS:U $k) {

    }
    method deploy_pod_security_policies(::CLASS:U $k) {

    }
    method create_user_service_account(::CLASS:U $k) {

    }
    method create_kubeconfig_admin(::CLASS:U $k) {

    }
    method create_kubeconfig_controller(::CLASS:U $k) {

    }
    method create_kubeconfig_worker(::CLASS:U $k) {

    }
    method create_admin_service_account(::CLASS:U $k) {

    }
    method configure_rbac(::CLASS:U $k) {

    }
    method wait_for_node(::CLASS:U $k) {

    }
}

class Cluster {
    has $!name;

    # network-id is stored on disk in our cluster config
    has $!network-id;
}

class LXD {
    has $!project = "default";

    method create-network(::CLASS:U $lxd, Str $name --> Str) {
        #my $rand;
        #$rand ~= ('0' .. 'z').pick() for 1..5;

        # check if it exists
        my $proc = run 'lxc', 'network', 'list', '--format=json', :out;
        my @parsed = from-json $proc.out.slurp: :close;
        my Bool $exists = True if grep $network-id, @parsed.map: &{ $_{'name'}};

        # create network if it doesn't exist
        unless $exists {
            run 'lxc', 'network', 'create', $name;
        }

        $name;
    }
    method delete-network(::CLASS:U $lxd) {
    
    }
    method create-storage-pool(::CLASS:U $lxd) {
        #TODO
    
    }
    method launch-container(::CLASS:U $lxd) {
    
    }
    method launch-etcd(::CLASS:U $lxd) {
    
    }
    method container-ipv4-address(::CLASS:U $lxd) {
    
    }
    method copy-cni-plugins(::CLASS:U $lxd) {
    
    }
    method copy-crio-files(::CLASS:U $lxd) {
    
    }
    method copy-etcd-binaries(::CLASS:U $lxd) {
    
    }
    method copy-k8s-binaries(::CLASS:U $lxd) {
    
    }
    method copy-runc-binaries(::CLASS:U $lxd) {
    
    }
    method container-status-code(::CLASS:U $lxd) {
    
    }

}

class Kubedee {
    has $.dir;
    has $.config-dir;
    has $.cache-dir;
    has $.cluster-name;

    method init-dirs {
        # make dirs;
        mkdir $!dir;
        mkdir $!config-dir;
        mkdir $!cache-dir;
        mkdir "{$!dir}/clusters/{$!cluster-name}";
    }

    method init-lxd-resources {
        # create network
        LXD.create-network: "kubedee-{$!cluster-name}";
        # create storage pool
        # TODO: just use default for now but allow this

        # create base image (kubedee::prepare_container_image)
        # in LXD this is just a few packages: socat, libgpgme11 kitty-terminfo
    }
    # Kubedee
    # LXD high level routines
    # create certs, kubeconfig, lxc device add, systemd units

    method prepare-container-image(::CLASS:U $kd) {
        LXD.image-list
    
    }

    method fetch-etcd(::CLASS:U $kd) {

    }

    method fetch-cni-plugins(::CLASS:U $kd) {

    }

    method fetch-crio(::CLASS:U $kd) {
    }

    method fetch-k8s(::CLASS:U $kd) {
        # fetch kube-apiserver,kube-controller-manager,kubectl,kubelet,kube-proxy,kube-scheduler
    }

    method fetch-runc(::CLASS:U $kd) {
    }

    method log(::CLASS:U $kd) {
    }

    method prune-old-caches(::CLASS:U $kd) {
        # ~/.local/share/kubedee/cache/v0.7.0-67-g40e761a-dirty
        my @dirs = dir $!cache-dir;
        for @dirs -> $d {
            say "pruning dir $d";
            rmdir $d;
        }
    }

    method smoke-test(::CLASS:U $kd) {
    }

    method configure-worker(::CLASS:U $kd) {
    }

    method configure-controller(::CLASS:U $kd) {
    }

    method configure-etcd(::CLASS:U $kd) {
    }

    method apiserver-wait-running(::CLASS:U $kd) {
    }

    method container-wait-running(::CLASS:U $kd) {
    }


}

## Main subroutines
## todo: validate cluster name


multi sub MAIN('controller-ip', Str $cluster-name) {
    say "controller-ip...";
}
multi sub MAIN('create', 
    Str $cluster-name,
    Str :$kubernetes-version,
    Int :$num-worker = 2,
    Bool :$no-set-context,
    Array[Str] :@apiserver-set-hostnames,
    Str :$bin-dir = "./_output/bin",
) {
    say "create...";
    my $kd = Kubedee.new(cluster-name => $cluster-name, dir => $kubedee-dir, cache-dir => $kubedee-cache-dir,
        config-dir => $kubedee-config-dir);
    $kd.init-dirs;
    $kd.init-lxd-resources;

    
    ## assemble k8s
    # download k8s binaries
    # copy k8s binaries
    # copy etcd binaries
    # copy crio files
    # copy runc binaries
    # copy cni plugins

    ## create CAs
    # etcd
    # k8s
    # aggregation

    ## create client certs
    # aggregation client
    # admin client
}

multi sub MAIN('up',
    Str $cluster-name,
    Str :$kubernetes-version,
    Int :$num-worker = 2,
    Bool :$no-set-context,
    Array[Str] :@apiserver-set-hostnames,
    Str :$bin-dir = "./_output/bin",
) {
    say "up...";
}

multi sub MAIN('start', Str $cluster-name) {
    # ensure cluster exists
    # gen random suffix

    # prep lxd container image
    # launch lxd container
    # configure worker (?)

}
multi sub MAIN('create-admin-sa', Str $cluster-name) {
}
multi sub MAIN('create-user-sa', Str $cluster-name) {
}
multi sub MAIN('delete', Str $cluster-name) {
}
multi sub MAIN('etcd-env', Str $cluster-name) {
}
multi sub MAIN('kubectl-env', Str $cluster-name) {
}
multi sub MAIN('list', Str $cluster-name) {
}
multi sub MAIN('smoke-test', Str $cluster-name) {
}
multi sub MAIN('start-worker', Str $cluster-name) {
}
multi sub MAIN('version') {
}

# TODO use this override
sub USAGE() {
    print Q:c:to/EOH/; 
kubedee - unreleased

Usage:
  kubedee [options] controller-ip <cluster name>     print the IPv4 address of the controller node
  kubedee [options] create <cluster name>            create a cluster
  kubedee [options] create-admin-sa <cluster name>   create admin service account in cluster
  kubedee [options] create-user-sa <cluster name>    create user service account in cluster (has 'edit' privileges)
  kubedee [options] delete <cluster name>            delete a cluster
  kubedee [options] etcd-env <cluster name>          print etcdctl environment variables
  kubedee [options] kubectl-env <cluster name>       print kubectl environment variables
  kubedee [options] list                             list all clusters
  kubedee [options] smoke-test <cluster name>        smoke test a cluster
  kubedee [options] start <cluster name>             start a cluster
  kubedee [options] start-worker <cluster name>      start a new worker node in a cluster
  kubedee [options] up <cluster name>                create + start in one command
  kubedee [options] version                          print kubedee version and exit

Options:
  --apiserver-extra-hostnames <hostname>[,<hostname>]   additional X509v3 Subject Alternative Name to set, comma separated
  --bin-dir <dir>                                       where to copy the k8s binaries from (default: ./_output/bin)
  --kubernetes-version <version>                        the release of Kubernetes to install, for example 'v1.12.0'
                                                        takes precedence over `--bin-dir`
  --no-set-context                                      prevent kubedee from adding a new kubeconfig context
  --num-worker <num>                                    number of worker nodes to start (default: 2)
EOH
}

