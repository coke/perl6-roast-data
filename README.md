# Perl6 Roast Data

This project contains tools for running the perl6 spec test suite
(roast) by several different implementations, as well as tracking the
results of those runs.

See "perl6\_pass\_rates.csv" for the data, with a pretty version here:
https://github.com/coke/perl6-roast-data/blob/master/perl6_pass_rates.csv

Each implementation's last run is checked in under a corresponding
".out" file in the log/ directory. Check your implementation's file for
any failures or unexpected passes.

Note - the percentage column shows the percentage of the implementations
against each other for that day's run - so the highest number of passes
is always 100%, and the others are in relation to that number. So,
100% doesn't mean "passes every spectest". 

# Why don't all tests pass?

Each implementation shares roast with all the other
implementations. If a test is added, it might not be immediately
fudged to work on all implementations - in fact, depending on what
is being tested, the entire file may start failing in some
implementations.

The test numbers are run daily from a limited cron environment. If
the test is expecting things (like an environment variable) these
assumptions need to be added to the implementation's script in
bin/
 
Finally, these tests are run on a schedule; it's not expected that
commits to spec and to an implementation will be synchronized
with the running of this harness; give new tests a day to settle in.

If you notice a test is continually failing (check the history of the
implementation's .out file), please open a ticket with that implementation,
or keep reading if you want to fix it.

# How to Help

## rakudo

The most complete implementation/vm combination, any failures here
are from a regression, or from a newly added or changed test that doesn't
pass. In either case, please open an RT (email to rakudobug at perl
dot org), get a ticket number, and fudge the test, giving the ticket #.

There are multiple backends (JVM, MoarVM, MoarVM-nojit) and a test may fail on
any or all of these backends. Be sure to mark the ticket in RT with
the appropriate vm, and only fudge the test for the appropriate backend.
(#?rakudo for all backends, #?rakudo.jvm for, e.g. the JVM backend)

## pugs

## niecza

These versions are in maintenance mode.
Any tests that are not passing should be fudged with a todo if possible,
or a skip if necessary.
