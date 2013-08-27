# Perl6 Roast Data

This project contains tools for running the perl6 spec test suite
(roast) by several different implementations, as well as tracking the
results of those runs.

See "perl6_pass_rates.csv" for the data, with a pretty version here:
https://github.com/coke/perl6-roast-data/blob/master/perl6_pass_rates.csv

Each implementation's last run is checked in under a corresponding
".out" file. Check your implementation's file for any failures or
unexpected passes.

Note - the percentage column shows the percentage of the implmentations
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

## rakudo.parrot

The most complete implementation/vm combination, any failures here
are from a regression, or from a newly added or changed test that doesn't
pass. In either case, please open an RT (email to rakudobug at perl
dot org), get a ticket number, and fudge the test, giving the ticket #.

## rakudo.jvm

rakudo.jvm is nearly passing 100% of the spec tests, but is not
completely fudged yet - Any fudges marked "rakudo.jvm" will eventually
need tickets opened in RT (same as for rakudo.parrot), or to be fixed.
Any failures should be
considered under development. Tickets can also be opened for those
as well - if you open a ticket, please fudge the test and add the RT #
to the ticket.

## pugs

Since Pugs is in maintenance mode, any new tests are not
likely to get a patch to work; To keep Pugs green, any failing tests
should be fudged. For most tests, this involves prefixing the test
with:

    #?pugs todo
  
If this still doesn't allow the test file to complete, change the todo
to a skip - this requires a reason; either put in the error diagnostic
or the word "parsefail", e.g.:

    #?pugs skip 'No compatible multi variant found: "&is"'

If you still can't get a test file to pass, drop by #perl6 on freenode.

## niecza

Niecza is in maintenance mode, but unlike pugs, may still get some bug fixes.
Any tests that are not passing need a ticket
opened in https://github.com/sorear/niecza/issues, and then need to be fudged
with a reference to that ticket number.
