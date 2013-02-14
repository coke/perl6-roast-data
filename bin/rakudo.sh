#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo
git clone git://github.com/rakudo/rakudo.git
cd rakudo
ln -s ../../roast t/spec
perl Configure.pl --gen-parrot
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

perl t/spec/test_summary rakudo 2>&1 | tee ../rakudo_summary.out
