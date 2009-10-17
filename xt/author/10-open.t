#!perl

use strict;
use warnings;
use Test::More;

use Browser::Open qw( open_browser );

my $ok = open_browser('http://127.0.0.1/');
ok(defined($ok), 'Found command to open a browser');
is($ok, 0, 'No problems running command');

done_testing();