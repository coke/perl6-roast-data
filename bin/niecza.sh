#!/bin/sh

rm -rf niecza

# remove stale compiled file slipping through the cracks
rm -r ~/.local/share/NieczaModuleCache

# default to sysperl
PATH=/usr/local/bin:$PATH

git clone git://github.com/sorear/niecza.git
cd niecza
ln -s ../../roast t/spec
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 90; ulimit -v 1260720; ulimit -c 0; nice -20 mono ./run/Niecza.exe @ARGV"' >> perl6
chmod a+x ./perl6
make all

# some tests require a LANG.
export LANG=en_US.UTF-8

mono ./run/Niecza.exe -e "say 'BUILD SETTING'"
perl t/spec/test_summary niecza 2>&1 | tee ../log/niecza_summary.out
