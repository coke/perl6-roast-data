#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf nqp.jvm
git clone repos/nqp.git nqp.jvm
cd nqp.jvm
perl Configure.pl --backends=jvm
make -j all

make test 2>&1 | tee ../log/nqp.jvm_summary.out
