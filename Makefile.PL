use strict;
use lib '.';
use inc::Module::Install;

name                ('Cookie-Parser');
license             ('perl');
author              ('Agent Zhang <agentzh@yahoo.cn>');
perl_version        ('5.006001');
all_from            ('lib/Cookie/Parser.pm');

cc_inc_paths    '.';
cc_files        (glob("*.c"), (-e 'Parser.c' ? () : 'Parser.c'));
cc_optimize_flags '-g3';
can_cc or die "This module requires a C compiler";
#auto_install();

WriteAll();

