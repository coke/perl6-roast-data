#!/bin/sh

LANG=en_US.UTF-8
export LANG

# Building pugs doesn't like our perlbrew, default to sysperl
PATH=/usr/local/bin:$PATH

#
# Warning - this doesn't handle the case where deps change
# - make dies and says "run cabal configure"
#

rm -rf Pugs.hs
git clone git://github.com/perl6/Pugs.hs.git
cd Pugs.hs
ln -s ../../roast t/spec
(cd Pugs && make)
echo "#!/usr/bin/env perl" > perl6
echo '$ENV{PUGS_USE_EXTERNAL_TEST}=1;' >> perl6
echo '$ENV{LC_ALL}="en_US.ISO-8859-1";' >> perl6
echo 'exec "ulimit -t 90; ulimit -v 1260720; ulimit -c 0; nice -20 ./Pugs/pugs -IPugs/ext/Test/lib @ARGV"' >> perl6
chmod a+x ./perl6
perl t/spec/test_summary pugs 2>&1 | tee ../pugs_summary.out
