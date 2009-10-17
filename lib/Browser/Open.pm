package Browser::Open;

use strict;
use warnings;
use Carp;
use File::Spec::Functions qw( catfile );

use parent 'Exporter';

@Browser::Open::EXPORT_OK = qw( open_browser open_browser_cmd );

my @known_commands = (
  [ 'darwin', '/usr/bin/open', 1 ],
  [ 'cygwin', 'start'],
  [ 'MSWin32', 'start'],
  [ 'linux', 'xdg-open'],
  [ 'linux', 'firefox'],
  [ '*', 'open'],
  [ '*', 'start'],
);

##################################

sub open_browser {
  my $url = shift;
  croak('Missing required parameter $url, ') unless $url;
  
  my $cmd = open_browser_cmd();
  return unless $cmd;
  
  return system($cmd, $url);
}

sub open_browser_cmd {
  foreach my $spec (@known_commands) {
    my ($osname, $cmd, $exact) = @$spec;
    next unless $osname eq $^O;
    
    return $cmd if $exact && -x $cmd;
    $cmd = _search_in_path($cmd);
    return $cmd if $cmd;
  }
  return;  
}


##################################

sub _search_in_path {
  my $cmd = shift;
  
  for my $path (split(/:/, $ENV{PATH})) {
    my $file = catfile($path, $cmd);
    return $file if -x $file;
  }
  return;
}

1;
