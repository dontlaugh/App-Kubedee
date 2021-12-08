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



# $certdir holds our cluster certificates and cfssl configs
#   $certdir/{ca.pem,ca-key.pem,ca-config.json,profile.k8s}
# 
# local -r cluster_name="${1}"
# local -r target_dir="${kubedee_dir}/clusters/${cluster_name}/certificates"
has Str $.certdir;
has Str $.ca-config-filename = 'ca-config.json';

method new($certdir) {
	self.bless(:$certdir);
}


# This method creates a file that is required to sign new certs.
# Note, this is required... it's easy to forget to call it.
method init-signing-config() {
    my $ca-config = Q:to/CA_CONFIG/;
		{
		  "signing": {
		    "default": {
		      "expiry": "8760h"
		    },
		    "profiles": {
		      "kubernetes": {
		        "usages": ["signing", "key encipherment", "server auth", "client auth"],
		        "expiry": "8760h"
		      }
		    }
		  }
		}
		CA_CONFIG
    my $fh = open :w, $!certdir.IO.add($!ca-config-filename);
    $fh.say: $ca-config;
    $fh.close;
}

# Within certdir, create ca-key.pem, ca.csr, ca.pem. If these exist, skip
# their creation.
# 
# This method emulates the following shell script:
#     cat cainit.json | cfssl gencert -initca - | cfssljson -bare ca
method create-certificate-authority(Str $ca-name, Str $cn) {
    my $json = Q:s:to/END/; 
		{
		  "CN": "$cn",
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

    my $proc = run 'cfssl', 'gencert', '-initca', '-', :out, :in, :err, cwd => $!certdir;
    $proc.in.say: $json;
    $proc.in.close;
    my $output = $proc.out.slurp;
    $proc.out.close;  # not needed?
    my $proc2 = run 'cfssljson', '-bare', $ca-name, :in, cwd => $!certdir;
    $proc2.in.say: $output;
    $proc2.in.close;
}


# CN also becomes the cert name
# emulate this
# cat <<EOF | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes - | cfssljson -bare admin
method create-certificate(Str $ca-name, Str $cn, $O, $OU, Str $profile = 'kubernetes', +@flags) {
    my $json = Q:s:to/END/; 
		{
		  "CN": "$cn",
		  "key": {
		    "algo": "rsa",
		    "size": 2048
		  },
		  "names": [
		    {
		      "C": "DE",
		      "L": "Berlin",
		      "O": "$O",
		      "OU": "$OU",
		      "ST": "Berlin"
		    }
		  ]
		}
		END

    my $proc = run 'cfssl', 'gencert', "-ca={$ca-name}.pem", "-ca-key={$ca-name}-key.pem", 
        '-config=ca-config.json', "-profile={$profile}", @flags, '-', :out, :in, :err, cwd => $!certdir;
    $proc.in.say: $json;
    $proc.in.close;
    my $output = $proc.out.slurp;
    $proc.out.close; 
    my $proc2 = run 'cfssljson', '-bare', $cn, :in, :err, cwd => $!certdir;
    $proc2.in.say: $output;
    $proc2.in.close;
}