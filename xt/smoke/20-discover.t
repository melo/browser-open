#!perl

use strict;
use warnings;
use Test::More;

use Browser::Open qw( open_browser_cmd );

# plan skip_all => "We found a command on this system ($^O), no need to discover more"
#   if open_browser_cmd();

## Ignore $^O restrictions for a moment
foreach my $spec (Browser::Open::_known_commands()) {
  my (undef, $cmd, $exact) = @$spec;
  
  $cmd = Browser::Open::_search_in_path($cmd) unless $exact;

  diag("Found '$cmd' for '$^O'") if $cmd && -x $cmd;
}

pass('thank you for your time to make Browser::Open better');
done_testing();