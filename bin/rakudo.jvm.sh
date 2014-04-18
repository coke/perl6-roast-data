#!/usr/bin/env bash

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.jvm
git clone repos/rakudo.git rakudo.jvm
git clone repos/nqp.git rakudo.jvm/nqp
git clone repos/roast.git rakudo.jvm/t/spec
cd rakudo.jvm
perl Configure.pl --backends=jvm --gen-nqp
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 90; ulimit -v 1260720; ulimit -c 0; nice -20 ./perl6-j @ARGV"' >> perl6
chmod a+x ./perl6

perl t/spec/test_summary rakudo.jvm 2>&1 | tee ../log/rakudo.jvm_summary.out
