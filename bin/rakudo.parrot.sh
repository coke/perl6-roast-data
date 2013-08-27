#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.parrot
git clone git://github.com/rakudo/rakudo.git rakudo.parrot
cd rakudo.parrot
ln -s ../../roast t/spec
perl Configure.pl --gen-parrot
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

perl t/spec/test_summary rakudo.parrot 2>&1 | tee ../rakudo.parrot_summary.out
