#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

my $word = "please help me";
if ($word =~ /Please/){   #=~为匹配，!~为不匹配，双斜线中间为要匹配的字符，应注意perl区分大小写
	say "polite";
}else {
	say "not polite";
}