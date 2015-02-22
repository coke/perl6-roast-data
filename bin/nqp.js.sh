#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

rm -rf nqp.js
git clone repos/nqp.git nqp.js
git clone repos/MoarVM.git nqp.js/MoarVM
cd nqp.js
# nqp is currently under development, have to cross compile
git checkout js
perl Configure.pl --gen-moar --backends=js,moar
make -j all

make js-test 2>&1 | tee ../log/nqp.js_summary.out
