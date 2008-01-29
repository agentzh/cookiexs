use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;
BEGIN { use_ok('Cookie::XS'); }

$Data::Dumper::Sortkeys = 1;

my $cookie = 'foo=a%20phrase;haha; bar=yes%2C%20a%20phrase; baz=%5Ewibble&leiyh; qux=%27';
my $res = Cookie::XS->parse($cookie);
is Dumper($res), <<'_EOC_';
$VAR1 = {
          'bar' => [
                     'yes, a phrase'
                   ],
          'baz' => [
                     '^wibble',
                     'leiyh'
                   ],
          'foo' => [
                     'a phrase',
                     'haha'
                   ],
          'qux' => [
                     '\''
                   ]
        };
_EOC_

