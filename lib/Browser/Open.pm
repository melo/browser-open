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
__END__

=head1 NAME

Browser::Open - open a browser in a given URL

=head1 SYNOPSIS

    use Browser::Open qw( open_browser );

    my $ok = open_browser($url);
    # ! defined($ok): no recognized command found
    # $ok == 0: command found and executed
    # $ok != 0: command found, error while executing

=head1 DESCRIPTION

The functions optionaly exported by this module allows you to open URLs
in the user browser.

A set of known commands is tested for presence, and the first one found
is executed.

The L<"open_browser"> uses the L<perlfunc/"system"> function to execute
the command. If you want more control, you can get the command with the
L<"open_browser_cmd"> function and then use whatever method you want to
execute it.


=head1 API

All functions are B<not> exported by default. You must ask for them
explicitly.


=head2 open_browser

    my $ok = open_browser($url);

Find an appropriate command and executes it with your C<$url>.

If no command was found, returns C<undef>.

If a command is found, returns the exit code of the command.

If no C<$url> is given, an exception will be thrown:
C<< Missing required parameter $url >>.


=head2 open_browser_cmd

    my $cmd = open_browser_cmd();

Returns the best command found to open a URL on your system.

If no command was found, returns C<undef>.


=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Pedro Melo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
