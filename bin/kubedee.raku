
use App::Kubedee;


# TODO move this to lib when you learn Raku :(
class Kubedee {
    has @!command-line;
    
    has $!kubernetes-version = "1.21";
    has $!num-workers = 2;
    
    method from-args(::?CLASS:U $k: @args) {
        $k.new( command-line => @args );

        #return $k
    }
    
    method run() {
        say "running...";
        say "command line is {@!command-line}"
    
    }
}

my %*SUB-MAIN-OPTS =
  :named-anywhere,
;


multi sub MAIN('controller-ip', Str $cluster-name) {
    say "controller-ip...";
}
multi sub MAIN('create', Str $cluster-name, Str :$kubernetes-version, Int :$num-worker,
    Bool :$no-set-context, Array[Str] :@apiserver-set-hostnames) {
    say "create...";
}
multi sub MAIN('up', Str $cluster-name, Str :$kubernetes-version, Int :$num-worker, 
    Bool :$no-set-context, Array[Str] :@apiserver-set-hostnames) {
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
sub USAGEx() {
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
