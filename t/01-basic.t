#!perl

use strict;
use warnings;
use Test::More;

use Browser::Open qw( open_browser open_browser_cmd );

my $cmd = open_browser_cmd();
ok($cmd, "got command '$cmd'");
ok(-x $cmd, '... and we can execute it');

diag("Found '$cmd' for '$^O'") if $cmd;
done_testing();
