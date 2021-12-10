unit class App::LXD;
use JSON::Fast;
has $!project = "default";


method launch(Str $name, Str $image, +@flags) {
	# slurpy args
    my $proc = run 'lxc', 'launch', $image, $name, @flags;
}

method container-status(Str $name --> Str) {
	my $proc = run 'lxc', 'list', '--format=json', :out;
	my @container-infos = from-json $proc.out.slurp: :close;
	my Str $status;
	for @container-infos -> %info {
		if %info{'name'} eq $name {
            return %info{'status'};
        }
	}
    # todo: handle this with enums or option types or something
    return 'notfound';
}

method create-network(::?CLASS:U $lxd: Str $name) {
    #my $rand;
    #$rand ~= ('0' .. 'z').pick() for 1..5;

    # check if it exists
    my $proc = run 'lxc', 'network', 'list', '--format=json', :out;
    my @parsed = from-json $proc.out.slurp: :close;
    my Bool $exists = True if grep $name, @parsed.map: &{ $_{'name'}};

    # ' 

    unless $exists {
        run 'lxc', 'network', 'create', $name;
    }

}
method delete-network(::?CLASS:U $lxd) {

}
method create-storage-pool(::?CLASS:U $lxd) {
    #TODO

}
method launch-container(::?CLASS:U $lxd) {

}
method launch-etcd(::?CLASS:U $lxd) {

}
method container-ipv4-address(::?CLASS:U $lxd) {

}
method copy-cni-plugins(::?CLASS:U $lxd) {

}
method copy-crio-files(::?CLASS:U $lxd) {

}
method copy-etcd-binaries(::?CLASS:U $lxd) {

}
method copy-k8s-binaries(::?CLASS:U $lxd) {

}
method copy-runc-binaries(::?CLASS:U $lxd) {

}
method container-status-code(::?CLASS:U $lxd) {

}
