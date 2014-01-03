#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.moar
git clone -b moar-support git://github.com/rakudo/rakudo.git rakudo.moar
cd rakudo.moar
ln -s ../../roast t/spec
perl Configure.pl --backends=moar --gen-moar=master --gen-nqp=master
make all

# default build generates a "perl6-m" - need "./perl6" for test_summary
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 90; ulimit -v 1260720; ulimit -c 0; nice -20 ./perl6-m @ARGV"' >> perl6
chmod a+x ./perl6

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

perl t/spec/test_summary rakudo.moar 2>&1 | tee ../rakudo.moar_summary.out
