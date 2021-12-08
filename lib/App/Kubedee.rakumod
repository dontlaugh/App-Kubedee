unit class App::Kubedee:ver<1.0.0>;


has $.state-dir;
has $.config-dir;
has $.cache-dir;
has $.cluster-name;

method new(Str $cluster-name, Str :$state-dir = "{%*ENV{'HOME'}}/.local/share/kubedee", Str :$config-dir = "{%*ENV{'HOME'}}/.config/kubedee") {

    my $cache-dir = "{$state-dir}/cache";
    self.bless(:$cluster-name, :$state-dir, :$config-dir, :$cache-dir);
}

method init-dirs {
    # make dirs;
    mkdir $!state-dir;
    mkdir $!config-dir;
    mkdir $!cache-dir;
    # make cluster-specific subdirectories
    mkdir "{$!state-dir}/clusters/{$!cluster-name}/certificates";
}

method cert-dir(--> Str) {
    "{$!state-dir}/clusters/{$!cluster-name}/certificates";
}


method prune-old-caches(::?CLASS:U $kd) {
    # ~/.local/share/kubedee/cache/v0.7.0-67-g40e761a-dirty
    my @dirs = dir $!cache-dir;
    for @dirs -> $d {
        say "pruning dir $d";
        rmdir $d;
    }
}

method smoke-test(::?CLASS:U $kd) {
}

method configure-worker(::?CLASS:U $kd) {
}

method configure-controller(::?CLASS:U $kd) {
}

method configure-etcd(::?CLASS:U $kd) {
}

method apiserver-wait-running(::?CLASS:U $kd) {
}

method container-wait-running(::?CLASS:U $kd) {
}