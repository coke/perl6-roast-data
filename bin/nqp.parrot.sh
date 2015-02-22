#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf nqp.parrot
git clone repos/nqp.git nqp.parrot
git clone repos/parrot nqp.parrot/parrot
cd nqp.parrot
perl Configure.pl --backends=parrot --gen-parrot --parrot-make-option='-j'
make -j all

make test 2>&1 | tee ../log/nqp.parrot_summary.out
