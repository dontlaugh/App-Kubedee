unit class App::CFSSL:ver<1.0.0>;

## We need to create all these:
#certificates/admin-key.pem
#certificates/admin.csr
#certificates/admin.pem
#certificates/aggregation-client-key.pem
#certificates/aggregation-client.csr
#certificates/aggregation-client.pem
#certificates/ca-aggregation-key.pem
#certificates/ca-aggregation.csr
#certificates/ca-aggregation.pem
#certificates/ca-config.json
#certificates/ca-etcd-key.pem
#certificates/ca-etcd.csr
#certificates/ca-etcd.pem
#certificates/ca-key.pem
#certificates/ca.csr
#certificates/ca.pem
#certificates/etcd-key.pem
#certificates/etcd.csr
#certificates/etcd.pem
#certificates/kube-controller-manager-key.pem
#certificates/kube-controller-manager.csr
#certificates/kube-controller-manager.pem
#certificates/kube-proxy-key.pem
#certificates/kube-proxy.csr
#certificates/kube-proxy.pem
#certificates/kube-scheduler-key.pem
#certificates/kube-scheduler.csr
#certificates/kube-scheduler.pem
#certificates/kubedee-optest-controller-key.pem
#certificates/kubedee-optest-controller.csr
#certificates/kubedee-optest-controller.pem
#certificates/kubedee-optest-worker-h1wt5x-key.pem
#certificates/kubedee-optest-worker-h1wt5x.csr
#certificates/kubedee-optest-worker-h1wt5x.pem
#certificates/kubedee-optest-worker-y94etu-key.pem
#certificates/kubedee-optest-worker-y94etu.csr
#certificates/kubedee-optest-worker-y94etu.pem
#certificates/kubernetes-key.pem
#certificates/kubernetes.csr
#certificates/kubernetes.pem



# $cert-dir holds our cluster certificates and cfssl configs
#   $cert-dir/{ca.pem,ca-key.pem,ca-config.json,profile.k8s}
# 
# local -r cluster_name="${1}"
# local -r target_dir="${kubedee_dir}/clusters/${cluster_name}/certificates"
has Str $.cert-dir;

method create_certificate_admin(Str $cluster-name) {

}
method create_certificate_aggregation_client() {

}
method create_certificate_authority_aggregation() {

}
method create_certificate_authority_etcd() {

}

# Within cert-dir, create ca-key.pem, ca.csr, ca.pem. If these exist, skip
# their creation.
method create-certificate-authority-k8s() {
    # cat cainit.json | cfssl gencert -initca - | cfssljson -bare ca
    my Str $json = Q:to/END/; 
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "DE",
      "L": "Berlin",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Berlin"
    }
  ]
}
END

    my $proc = run 'cfssl', 'gencert', '-initca', '-', :out, :in,  cwd => $!cert-dir;
    $proc.in.say: $json;
    $proc.in.close;
    my $output = $proc.out.slurp;
    $proc.out.close;  # not needed?
    my $proc2 = run 'cfssljson', '-bare', 'ca', :in, cwd => $!cert-dir;
    $proc2.in.say: $output;
    $proc2.in.close;
#    
#    # create ca-config.json
#    my $ca-config = Q:to/CA_CONFIG/;
#{
#  "signing": {
#    "default": {
#      "expiry": "8760h"
#    },
#    "profiles": {
#      "kubernetes": {
#        "usages": ["signing", "key encipherment", "server auth", "client auth"],
#        "expiry": "8760h"
#      }
#    }
#  }
#}
#CA_CONFIG
#    my $fh = open :w, 'ca-config.json';
#    $fh.say: $ca-config;
#    $fh.close;

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
