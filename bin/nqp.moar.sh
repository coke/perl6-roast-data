#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf nqp.moar
git clone repos/nqp.git nqp.moar
git clone repos/MoarVM.git nqp.moar/MoarVM
cd nqp.moar
perl Configure.pl --gen-moar --backends=moar --moar-option=--no-jit
make -j all

# swap out the default runner with one that is ulimited
#echo "#!/usr/bin/env perl" > perl6
#echo 'exec "ulimit -t 120; ulimit -v 2500000; ulimit -c 0; nice -20 ./perl6-m @ARGV"' >> perl6
#chmod a+x ./perl6

make test 2>&1 | tee ../log/nqp.moar_summary.out
