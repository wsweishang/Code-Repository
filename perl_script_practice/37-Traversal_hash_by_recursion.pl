#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

my $test_hash = {
    a => 'a',
    b => {
        d => 'd',
        e => 'e',
        f => {
            g => 'g',
            h => 'h',
        },
    },
    c => 'c',
    d => 'c',
};

sub flatten_hash {
    my %output = %{shift @_};
    my %args = @_;
    while (my ($key, $value) = each(%{$args{original_hash}})) {
        my @data_address = defined($args{keys_list}) ? @{$args{keys_list}} : ();
        push(@data_address, $key);

        if (ref($value) eq 'HASH') {
            %output = flatten_hash(\%output, original_hash => $value, keys_list => \@data_address);
        }
        else {
            my $addr = join('.', @data_address);
            $output{$addr} = $value;
        }
    }
    return %output;
}

#my $test_hash=();
#$test_hash{"a"}{"b"}{"c"}=1;
#$test_hash{"a"}{"c"}{"d"}=1;
#$test_hash{"b"}{"d"}{"e"}=1;
#$test_hash{"b"}{"e"}{"f"}=1;
#print Dumper (\$test_hash);

my %empty;
my %res = flatten_hash(\%empty, original_hash => $test_hash, arguments => []);
print "Test hash:\n";
print Dumper($test_hash);
print "Result\n";
print Dumper(\%res);


