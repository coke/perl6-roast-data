#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

WORKDIR=rakudo.moar-glr
rm -rf $WORKDIR
git clone repos/rakudo.git $WORKDIR
git clone repos/nqp.git $WORKDIR/nqp
git clone repos/MoarVM.git $WORKDIR/nqp/MoarVM
git clone repos/roast.git $WORKDIR/t/spec
cd $WORKDIR
git checkout glr
cd t/spec
git checkout glr
cd ../..
perl Configure.pl --gen-moar --gen-nqp --backends=moar
make -j all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 120; ulimit -v 2500000; ulimit -c 0; nice -20 ./perl6-m @ARGV"' >> perl6
chmod a+x ./perl6

perl t/spec/test_summary rakudo.moar 2>&1 | tee ../log/rakudo.moar-glr_summary.out
