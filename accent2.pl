use strict;
use vars qw($VERSION %IRSSI);
use utf8;
use Text::Unidecode;

use Irssi;
$VERSION = '2.0';
%IRSSI = (
    authors     => 'Tamas SZERB, Mate ORY',
    contact     => 'toma@rulez.org, orymate@ubuntu.com',
    name        => 'accent2',
    description => 'Drops diacritics sent to a set of channels.',
    license     => 'GPL',
);

sub accent2_out {
    my ($msg, $serv, $chan) = @_;
    return unless ($chan or ($msg !~ m!^/!));
    my $channelname = $chan->{name};
    my $emitted_signal = Irssi::signal_get_emitted();
    my $debug=Irssi::settings_get_bool('accent2_debug');
    $debug and Irssi::print("signal emitted: $emitted_signal Msg: $msg;" .
       " Server: '$serv' Channel: '$channelname'");
    my $list = '|' . Irssi::settings_get_str('accent2_strip') . '|';
    $list =~ s/[ ,:|]+/\|/g ;
    if($list  =~ /[|]$channelname[|]/ ) {
        my $escape = Irssi::settings_get_str('accent2_escape');
        if ($msg =~ /^$escape/) {
            $debug and Irssi::print("drop prefix");
            $msg =~ s/^$escape//;
        }
        else {
            $debug and Irssi::print("do unidecode");
            utf8::decode($msg); # works that way with my installations
            unidecode($msg);
        }
        Irssi::signal_continue($msg, $serv, $chan);
    }
    elsif ($debug) {
        Irssi::print("don't unidecode");
    }
}


#main():


Irssi::settings_add_str('lookandfeel', 'accent2_strip', '#list #of #channels');
Irssi::settings_add_str('lookandfeel', 'accent2_escape', '§§');

Irssi::settings_add_bool('lookandfeel', 'accent2_debug', 0);

Irssi::signal_add_first('send command', 'accent2_out');

#startup info:
Irssi::print("Diacritic stripper by toma & maat");

