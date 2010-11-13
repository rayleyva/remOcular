package remOcular::MojoApp;
use strict;
use warnings;

use remOcular::JsonRpcService;
use remOcular::Config;

use base 'Mojolicious';

sub startup {
    my $self = shift;
    my $conf = remOcular::Config->new( 
        file=> $ENV{REMOCULAR_CONF} || $self->home->rel_file('etc/remocular.cfg')
    );
    
    my $services = {
        remOcular => new remOcular::JsonRpcService(
            cfg => $conf->parse_config()
        ),
    };
            
    my $r = $self->routes;
    
    $r->route('/jsonrpc')->to('jsonrpc#dispatch', 
        services    => $services, 
        debug       => 0,        
        namespace   => 'MojoX::Dispatcher::Qooxdoo',        
    );
    
}

1;
