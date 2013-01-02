#!/bin/sh

LANG=en_US.UTF-8
export LANG

perlbrew off # Building pugs doesn't like our perlbrew.

#
# Warning - this doesn't handle the case where deps change
# - make dies and says "run cabal configure"
#

rm -rf Pugs.hs
git clone git://github.com/perl6/Pugs.hs.git
cd Pugs.hs
ln -s ../../roast t/spec
(cd Pugs && make)
/home/coke/perl5/perlbrew/perls/perl-5.14.2/bin/perl t/spec/test_summary pugs 2>&1 | tee ../pugs_summary.out
