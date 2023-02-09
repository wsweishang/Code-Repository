#!/usr/bin/perl

use strict;
use warnings;
use Encode;

print "inter file path : \n";
chomp (my $file_path = <STDIN>);
(my $file_type = $file_path) =~ s/.*(\..*)/$1/;

open (INTXT, "<$file_path") or die "$!";
open (OUT, ">${file_path}_chonverted.${file_type}") or die "$!";
while (my $file_content = <INTXT>) {
	chomp $file_content;
	$file_content = encode("utf-8", decode("gbk", $file_content));
#	$file_content = encode("gbk", decode("utf-8", $file_content));
#	$file_content = encode("gb2312", decode("utf-8", $file_content));
	print OUT "$file_content\n";
}
close (INTXT);
close (OUT);



