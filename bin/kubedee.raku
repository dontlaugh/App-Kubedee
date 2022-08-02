use JSON::Fast;
use App::CFSSL;
use App::LXD;
use App::Kubedee;
use App::Kubectl;

my %*SUB-MAIN-OPTS =
  :named-anywhere,
;


## Main subroutines

multi sub MAIN('controller-ip', Str $cluster-name) {
    say "controller-ip...";
}

multi sub MAIN('create', Str $cluster-name) {
    say "create...";
    my $kd = App::Kubedee.new: $cluster-name;
    $kd.init-dirs;

    my $ca = App::CFSSL.new($kd.cert-dir);
    $ca.init-signing-config;
    # this is a lot of params, maybe named params or another object would be more clear
    $ca.create-certificate-authority: 'ca', 'Kubernetes', 'Kubernetes', 'CA';
    $ca.create-certificate-authority: 'ca-aggregation', 'Kubernetes Front Proxy CA',
        'Kubernetes Front Proxy', 'CA';
    $ca.create-certificate-authority: 'ca-etcd', 'etcd', 'etcd', 'CA';
    # O and OU are a part of our permissions for these, iiuc
    $ca.create-certificate: 'ca', 'admin', 'system:masters', 'kubedee';
    $ca.create-certificate: 'ca-aggregation', 'kube-apiserver', 'kube-apiserver', 'kubedee';
}

multi sub MAIN('start', Str $cluster-name) {

my $kd = App::Kubedee.new: $cluster-name;
    $kd.launch-etcd;
    $kd.launch-controller;
    $kd.launch-worker;
    
    $kd.configure-etcd;
    
}

multi sub MAIN('test') {
    my $lxd = App::LXD.new;
    my $status = $lxd.container-status('redis');
    until $status eq 'Running' {
        $status = $lxd.container-status('redis');
        say "status: $status";
        sleep 1;
    }
    say "done";
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

