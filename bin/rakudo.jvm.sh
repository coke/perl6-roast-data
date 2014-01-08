#!/usr/bin/env bash

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.jvm
git clone repos/rakudo.git rakudo.jvm
git clone repos/nqp.git rakudo.jvm/nqp
cd rakudo.jvm
ln -s ../../roast t/spec
perl Configure.pl --backends=jvm --gen-nqp
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited
# temporarily ignore memory ulimit. ## ulimit -v 2048576

perl t/spec/test_summary rakudo.jvm 2>&1 | tee ../log/rakudo.jvm_summary.out
