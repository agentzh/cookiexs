package Cookie::XS;

use strict;
use warnings;

use FindBin;
use Data::Dumper;

our $VERSION;

use XSLoader;
BEGIN {
    $VERSION = '0.04';
    XSLoader::load(__PACKAGE__, $VERSION);
}

sub fetch {
    my $class = shift;
    my $raw_cookie = $ENV{HTTP_COOKIE} || $ENV{COOKIE} or return;
    $class->parse($raw_cookie);
}

sub parse {
    parse_cookie($_[1]);
}

1;
__END__

=head1 NAME

Cookie::XS - Cookie parser in C

=head1 VERSION

This document describes Cookie::XS 0.04 released on Mar 3, 2008.

=head1 SYNOPSIS

    use Cookie::XS;

    my $raw_cookie = 'foo=a%20phrase;haha; bar=yes%2C%20a%20phrase; baz=%5Ewibble&leiyh; qux=%27';
    my $res = Cookie::XS->parse($raw_cookie);
    # $res is something like:
    #    {
    #      'bar' => [
    #                 'yes, a phrase'
    #               ],
    #      'baz' => [
    #                 '^wibble',
    #                 'leiyh'
    #               ],
    #      'foo' => [
    #                 'a phrase',
    #                 'haha'
    #               ],
    #      'qux' => [
    #                 '\''
    #               ]
    #    };

    # or directly read raw cookies from the CGI environments:
    $res = Cookie::XS->fetch;

=head1 DESCRIPTION

This module implements a very simple parser for cookies used in HTTP applications. We've found CGI::Simple::Cookie rather insufficient in our L<OpenResty> project, hence the rewrite.

This stuff is still in B<pre-alpha> stage and the API is still in flux. We're just following the "release early, releaes often" guideline. So please check back often ;)

=head1 METHODS

We currently implement 2 static methods, C<parse> and C<fetch>. They work mostly the same way as those methods found in L<CGI::Cookie> and L<CGI::Simple::Cookie> but with the exception that our version returns plain Perl data structures rather than hashes of Perl objects for performance reasons.

We'll implement some dump methods in the near future.

=head1 SOURCE CONTROL

For the very latest version of this module, check out the source from
the SVN repos below:

L<http://svn.openfondry.org/cookieparser>

There is anonymous access to all. If you'd like a commit bit, please let
us know. :)

=head1 BUGS

Please report bugs or send wish-list to
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Cookie-XS>.

=head1 SEE ALSO

L<CGI::Cookie>, L<CGI::Cookie::Simple>.

=head1 AUTHOR

yuting E<gt>yuting at alibaba-inc dot comE<lt>.
agentzh E<gt>agentzh at yahoo dot cnE<lt>.

=head1 COPYRIGHT

Copyright (c) 2008 by Yahoo! Dhina EEEE Works, Alibaba Inc.

=head1 License

The "MIT" License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

