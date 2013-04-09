use v6;

my $day;
my %status;

my @dates;
for lines open 'perl6_pass_rates' -> $line {
    if $line ~~ /^ '#' \s* (\d\d)\/(\d\d)\/(\d\d\d\d) / {
       $day  = Date.new(+$2, +$0, +$1);
       @dates.push($day);
    } elsif $line ~~ /^ '"' (\w+) '"' \s* ',' \s* (\d+) \s* ',' \s* (\d+)/ {
        %status{~$0}{$day} = $2 eq "0";
    }
}

my @x = gather for %status.keys -> $impl {
    my $state;
    my $date;
    for @dates -> $day {
        my $new_state = %status{$impl}{$day};

        FIRST $date = $day;
        if ! $state.defined { $state = $new_state }

        if ($state ne $new_state) {
            my $diff = @dates[0] - $day;
            take "$impl has been " ~ ($state ?? "clean" !! "dirty") ~
               " for " ~ $diff ~ " day" ~ ($diff != 1 ?? "s" !! "") ~ ".";
            last;
        }
 
        $date = $day;
    }
}

say @x.join(" ");
