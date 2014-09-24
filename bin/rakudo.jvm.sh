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
export PERL6LIB=`pwd`/lib

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited and uses evalserver
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 120; ulimit -v 2500000; ulimit -c 0; nice -20 perl eval-client.pl TESTCOOKIE run @ARGV";' >> perl6
chmod a+x ./perl6

# start eval server
exec 3> >( ./perl6-eval-server -bind-stdin -cookie TESTCOOKIE -app perl6.jar 2>&1 | 
               tee eval-server.log )

perl t/spec/test_summary rakudo.jvm 2>&1 | tee ../log/rakudo.jvm_summary.out
