use JSON::Fast;
use App::CFSSL;
use App::LXD;
use App::Kubedee;
use App::Kubectl;

my $kubedee_version = "1.0.0";
my $home = %*ENV{'HOME'};
my $kubedee-dir = "{$home}/.local/share/kubedee";
my $kubedee-config-dir = "{$home}/.config/kubedee";
my $kubedee-cache-dir = "{$kubedee-dir}/cache/{$kubedee_version}";
my $install_psps = False;

my %*SUB-MAIN-OPTS =
  :named-anywhere,
;


## todos: 
# * validate cluster name input

## Main subroutines

multi sub MAIN('controller-ip', Str $cluster-name) {
    say "controller-ip...";
}

multi sub MAIN('create', 
    Str $cluster-name,
    Str :$kubernetes-version = 'v1.21.1',
    Int :$num-worker = 2,
    Bool :$no-set-context,
) {
    say "create...";
    my $kd = App::Kubedee.new(cluster-name => $cluster-name, dir => $kubedee-dir, cache-dir => $kubedee-cache-dir,
        config-dir => $kubedee-config-dir);
    $kd.init-dirs;
    $kd.init-lxd-resources;
    say "helllo {$kd.cert-dir}";

    my $ca = App::CFSSL.new(cert-dir => "{$kd.cert-dir}");
    $ca.create-certificate-authority-k8s;

    
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
# https://docs.raku.org/language/create-cli#sub_USAGE
sub USAGEax() {
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

