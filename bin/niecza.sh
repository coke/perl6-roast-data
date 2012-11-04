#!/bin/sh

rm -rf niecza
git clone git://github.com/sorear/niecza.git
cd niecza
ln -s ../../roast t/spec
make all
/home/coke/perl5/perlbrew/perls/perl-5.14.2/bin/perl t/spec/test_summary niecza 2>&1 | tee ../niecza_summary.out
