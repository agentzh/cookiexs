package Cookie::XS;

use strict;
use warnings;

use FindBin;
use Data::Dumper;
#our $VERSION = '0.04';

use XSLoader;
BEGIN {
    XSLoader::load(__PACKAGE__);
}

mkdir '/tmp' if !-d '/tmp';
mkdir '/tmp/_Inline' if !-d '/tmp/_Inline';

sub fetch {
    my $class = shift;
    my $raw_cookie = $ENV{HTTP_COOKIE} || $ENV{COOKIE} or return;
    $class->parse($raw_cookie);
}

sub parse {
    parse_cookie($_[1]);
}

1;

