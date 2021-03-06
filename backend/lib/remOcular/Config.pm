package remOcular::Config;
use strict;

=head1 NAME

remOcular::Config - The Configuration File

=head1 SYNOPSIS

 use remOcular::Config;

 my $parser = remOcular::Config->new(file=>'/etc/SmokeTracessas/system.cfg');
 my $cfg = $parser->parse_config();
 my $pod = $parser->make_pod();

=head1 DESCRIPTION

Configuration reader for remOcularssas.

=cut

use vars qw($VERSION);
$VERSION   = '0.01';
use Carp;
use Config::Grammar;
use base qw(Mojo::Base);

__PACKAGE__->attr('file');
    

=head1 METHODS

All methods inherited from L<Mojo::Base>. As well as the following:

=cut

=head2 $x->B<parse_config>(I<path_to_config_file>)

Read the configuration file and die if there is a problem.

=cut

sub parse_config {
    my $self = shift;
    my $cfg_file = shift;
    my $parser = $self->_make_parser();
    my $cfg = $parser->parse($self->file) or croak($parser->{err});
    return $cfg;
}

=head2 $x->B<make_config_pod>()

Create a pod documentation file based on the information fro all config actions.

=cut

sub make_pod {
    my $self = shift;
    my $parser = $self->_make_parser();
    my $E = '=';
    my $footer = <<"FOOTER";

${E}head1 COPYRIGHT

Copyright (c) 2009 by OETIKER+PARTNER AG. All rights reserved.

${E}head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

${E}head1 AUTHOR

S<Tobias Oetiker E<lt>tobi\@oetiker.chE<gt>>

${E}head1 HISTORY

 2009-07-13 to 1.0 first version

FOOTER
    my $header = $self->_make_pod_header();    

    return $header.$parser->makepod().$footer;
}



=item $x->B<_make_pod_header>()

Returns the header of the cfg pod file.

=cut

sub _make_pod_header {
    my $self = shift;
    my $E = '=';
    return <<"HEADER";
${E}head1 NAME

remocular.cfg - The remOcular configuration file

${E}head1 SYNOPSIS

 *** General ***
 admin_name = tobi oetiker
 admin_link = http://tobi.oetiker.ch
 plugin_path = /var/lib/remocular/plugin
 secret = MyCookieSecret
 log_file = /tmp/remocular.log
 
 *** Plugin ***
 +remOcular::Plugin::TraceRoute
 +remOcular::Plugin::IoStat
 +remOcular::Plugin::Df
 +remOcular::Plugin::IoStat
 +remOcular::Plugin::MpStat
 +remOcular::Plugin::Top

${E}head1 DESCRIPTION

Configuration overview

${E}head1 CONFIGURATION

HEADER

}

=item $x->B<_make_parser>()

Create a parse config parser for remocular.

=cut

sub _make_parser {
    my $self = shift;
    my $E = '=';
    my $grammar = {
        _sections => [ qw(General Plugin)],
        _mandatory => [qw(General Plugin)],
        General => {
            _doc => 'Global configuration settings for remOcular',
            _vars => [ qw(admin_name admin_link plugin_path secret log_file) ],
            _mandatory => [ qw(admin_name admin_link secret) ],
            admin_name => { _doc => 'who is running this service' },
            admin_link => { _doc => 'link for service admin' },
            secret => { _doc => 'secret for signing cookies' },
            plugin_path => { _doc => 'remocular plugins are perlmodules and they get found in the same way as perl modules. If you have extra locations to look for them. Set them here.' },
            log_file => { _dor => 'write a log file to this location'},
        },
        Plugin => {
            _doc => 'Select the Plugins to run in your setup',
            _sections => [ qw(/\S+/) ],
            '/\S+/' => {
                _order => 1,
                _doc => 'Plugin Name',
                _example => 'remOcular::Plugin::TraceRoute',
                _vars => [ '/\S+/' ],
                '/\S+/' => {_doc => 'arbitrary plugin properties'},
            }
        },
    };
    my $parser =  Config::Grammar->new ($grammar);
    return $parser;
}

1;
__END__

=back

=head1 COPYRIGHT

Copyright (c) 2008 by OETIKER+PARTNER AG. All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 AUTHOR

S<Tobias Oetiker E<lt>tobi@oetiker.chE<gt>>

=head1 HISTORY

 2008-10-07 to 1.0 first version

=cut

# Emacs Configuration
#
# Local Variables:
# mode: cperl
# eval: (cperl-set-style "PerlStyle")
# mode: flyspell
# mode: flyspell-prog
# End:
#
# vi: sw=4 et

