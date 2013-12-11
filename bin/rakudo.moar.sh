#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.moar
git clone git://github.com/rakudo/rakudo.git rakudo.moar
cd rakudo.moar
git checkout moar-support
ln -s ../../roast t/spec
perl Configure.pl --backends=moar --gen-moar=master --gen-nqp=master
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

perl t/spec/test_summary rakudo.moar 2>&1 | tee ../rakudo.moar_summary.out
