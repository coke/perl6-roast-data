#!/usr/bin/env bash

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf rakudo.jvm
git clone git://github.com/rakudo/rakudo.git rakudo.jvm
cd rakudo.jvm
ln -s ../../roast t/spec
git clone git://github.com/perl6/nqp.git
cd nqp
perl ConfigureJVM.pl --prefix=../install-jvm
make install
cd ..
perl ConfigureJVM.pl 
make all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=`pwd`/lib:.

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited
# temporarily ignore memory ulimit. ## ulimit -v 2048576

exec 3> >( ./perl6-eval-server -bind-stdin -cookie TESTCOOKIE -app perl6.jar 2>&1 | 
               tee eval-server.log )

mv perl6 p6
echo "#!/usr/bin/env perl" > perl6
echo 'exec "perl eval-client.pl TESTCOOKIE run @ARGV";' >> perl6
chmod u+x perl6

perl t/spec/test_summary rakudo.jvm 2>&1 | tee ../rakudo.jvm_summary.out
