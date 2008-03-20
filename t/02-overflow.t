use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;
BEGIN { use_ok('Cookie::XS'); }

$Data::Dumper::Sortkeys = 1;

my $COOKIE_LEN = 1024 * 4;

my $val_len = $COOKIE_LEN - 3;
my $cookie = 'a=' . ('a' x $val_len);
my $res = Cookie::XS->parse($cookie);
ok $res, 'res okay';
ok $res->{a}, 'var a parsed';
is $res->{a}->[0], 'a' x $val_len, "value okay for var a";

