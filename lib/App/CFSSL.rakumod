unit class App::CFSSL:ver<1.0.0>;


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
