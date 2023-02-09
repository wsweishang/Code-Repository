#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#====================================================================
#�ۺ���ϰ������ID��ȡ������ݣ���ȡһ�����ݵ��Ӽ������һ���µ��ļ�
#====================================================================

open(IN,"<D:/GeneID.txt") || die "$!";
open(INID,"<D:/ID.txt") || die "$!";
open(OUT,">D:/GeneID_out.txt") || die "$!";

my %GeneID=();
while (my $ID=<INID>){
	chomp $ID;
	$GeneID{$ID}=1;
}
close(INID);
while (my $GeneID=<IN>){
	chomp $GeneID;
	my @GeneID=split("\t",$GeneID);
	if (exists $GeneID{$GeneID[0]}){
		say OUT $GeneID;
	}
}
close(IN);
close(OUT);

