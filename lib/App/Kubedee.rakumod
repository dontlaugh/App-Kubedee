unit class App::Kubedee:ver<1.0.0>;

# our command line options we were passed
has @.command-line

has $!kubernetes-version = "1.21"
has $!num-workers = 2;


method from-args(::?CLASS:U $k: @args) {
    $k.new( command-line => @args );
}

method run() {

}

