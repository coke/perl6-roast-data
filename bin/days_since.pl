use v6;

my %status;

my $data-file = open 'perl6_pass_rates.csv';

my @lines = $data-file.lines;
@lines.shift; # skip headers

my $day;
sub get-a-day() {
    loop {
        my $line = shift @lines;

        if $line ~~ /^ '#' \s* (\d\d)\/(\d\d)\/(\d\d\d\d) / {
           $day  = ~$2 ~ "-" ~ $0 ~ "-" ~ $1;
           return ~$day;
        } elsif $line ~~ /^ '"' (\w+) '"' \s* ',' \s* (\d+) \s* ',' \s* (\d+)/ {
            %status{$day}{~$0} = $2 eq "0";
        }
    }
}

# only process as much as we need to get a state for each implementation

my $date;
my $next-date;

my $impl;
my $first = True; # work around no NOTFIRST and bug RT#118179

loop {
    FIRST $date = get-a-day(); # prime the pump
     
    $next-date = get-a-day();

    # Did the state change for any implemention?
    my $status = %status{$date};

    if ($first) {
        for $status.kv -> $compiler, $stats {
            $impl{$compiler}<end> = $date;
            $impl{$compiler}<state> = $stats;
        }
    } else {
        my $done = True;
        for $status.kv -> $compiler, $stats {
            next if $impl{$compiler}<start>:exists;
            if $impl{$compiler}<state> ne $status{$compiler} {
                $impl{$compiler}<start> = $date;
            } else {
                $done = False;
            }
        }
        last if $done;
    }

    $date = $next-date;
    $first = False;
}

my @results = gather for $impl.keys -> $compiler {
    my $diff = Date.new($impl{$compiler}<end>) - Date.new($impl{$compiler}<start>);
    take "$compiler has been " ~ ($impl{$compiler}<state> ?? "clean" !! "dirty") ~
               " for " ~ $diff ~ " day" ~ ($diff != 1 ?? "s" !! "") ~ ".";
}

say @results.join(" ");
