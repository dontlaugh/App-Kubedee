# This is the cli interface we are rebuilding from bash to raku
# list, create, up are most-used
#kubedee - v0.7.0-68-gebab5bd
#Usage:
#  kubedee [options] controller-ip <cluster name>     print the IPv4 address of the controller node
#  kubedee [options] create <cluster name>            create a cluster
#  kubedee [options] create-admin-sa <cluster name>   create admin service account in cluster
#  kubedee [options] create-user-sa <cluster name>    create user service account in cluster (has 'edit' privileges)
#  kubedee [options] delete <cluster name>            delete a cluster
#  kubedee [options] etcd-env <cluster name>          print etcdctl environment variables
#  kubedee [options] kubectl-env <cluster name>       print kubectl environment variables
#  kubedee [options] list                             list all clusters
#  kubedee [options] smoke-test <cluster name>        smoke test a cluster
#  kubedee [options] start <cluster name>             start a cluster
#  kubedee [options] start-worker <cluster name>      start a new worker node in a cluster
#  kubedee [options] up <cluster name>                create + start in one command
#  kubedee [options] version                          print kubedee version and exit
#
#Options:
#  --apiserver-extra-hostnames <hostname>[,<hostname>]   additional X509v3 Subject Alternative Name to set, comma separated
#  --bin-dir <dir>                                       where to copy the k8s binaries from (default: ./_output/bin)
#  --kubernetes-version <version>                        the release of Kubernetes to install, for example 'v1.12.0'
#                                                        takes precedence over `--bin-dir`
#  --no-set-context                                      prevent kubedee from adding a new kubeconfig context
#  --num-worker <num>                                    number of worker nodes to start (default: 2)

need App::Kubedee;

sub MAIN(*@args) {
    say "{@args}";

}
