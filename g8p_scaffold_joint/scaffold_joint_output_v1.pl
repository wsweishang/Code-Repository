#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;
use Data::Dumper;

#=====================================================================================================================
#scaffold_joint：scaffold序列拼接
#根据C_idella_female_scaffolds.fasta_out.txt依序提取C_idella_female_scaffolds.fasta.v1中的scaffold序列进行拼接
#一行LG (linkage group) 一行序列、总计24LGs\48行
#scaffold_joint_output1：C_idella_female_scaffolds_fasta_out.txt：拼接后的fasta文件
#scaffold_joint_output2：Cid_AnchorLGmapNew_0624_263scafford_out.txt：scaffold_ID、length、startsite、'+/-' 四项统计信息
#=====================================================================================================================

open (INFASTA,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_scaffolds.fasta.v1") or die "$!";
open (INORDER,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford.txt") or die "$!";
open (OUTPUT1,">G:/grasscarp_8populations/result/Scaffold/C_idella_female_scaffolds_fasta_out.txt") or die "$!";
open (OUTPUT2,">G:/grasscarp_8populations/result/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out.txt") or die "$!";

sub REV_COM{
	my $sequence=$_[0];
	my $rev_seq=reverse $sequence;
	$rev_seq=~tr/ATCG/TAGC/;
	return $rev_seq;
}

sub N100{
	my $n="0";
	for (;;){
		print OUTPUT1 "N";
		$n++;
		last if ($n>="100");
	}	
}

my @infasta=<INFASTA>;
my @inorder=<INORDER>;
my %scaffold=();
my %order=();
my $infasta=();
my $scaffold_ID=();
my $inorder=();
my @order=();
my %length=();

foreach $inorder(@inorder){
	chomp $inorder;
	@order=split(/\t/,$inorder);
	next unless ($order[0]=~/^[0-9]/);
	$order{$order[2]}= $order[0];	
}

foreach $infasta(@infasta){
	chomp $infasta;
	if ($infasta=~/^>.*/){
		$scaffold_ID=substr($infasta,1);	
		}
	$scaffold{$order{$scaffold_ID}}{$scaffold_ID}=$infasta if (exists $order{$scaffold_ID});	
}

foreach $inorder(@inorder){
	chomp $inorder;
	@order=split(/\t/,$inorder);
	next unless ($order[0]=~/^[0-9]/);
	if ($order[-1] eq "-"){
		my $rev_seq=&REV_COM($scaffold{$order{$order[2]}}{$order[2]});
		$scaffold{$order{$order[2]}}{$order[2]}=$rev_seq;
	}elsif ($order[-1] eq "+"){
		next;
	}else{
		say "error!";
	}
}

foreach $inorder(@inorder){
	chomp $inorder;
	@order=split(/\t/,$inorder);
	next unless ($order[0]=~/^[0-9]/);
	my $length=length $scaffold{$order{$order[2]}}{$order[2]};
	$length{$order[2]}=$length;
}

my $startsite="1";
my $n="1";
my @innum=@inorder;
say OUTPUT2 "LG\tscaffold_ID\tlength\tstartsite\t+/-";
foreach my $innum(@innum){
	chomp $innum;
	my @num=split(/\t/,$innum);
	next unless ($num[0]=~/^[0-9]/);
	$startsite="1" if ($n!=$num[0]);
	say OUTPUT2 "$num[0]\t$num[2]\t$length{$num[2]}\t$startsite\t$num[-1]";
	$startsite+=$num[5]+"100";
	$n=$n+"1" if ($n!=$num[0]);
}

my $m="1";
say OUTPUT1 ">CI01000342";
foreach my $innum(@innum){
	chomp $innum;
	my @num=split(/\t/,$innum);
	next unless ($num[0]=~/^[0-9]/);
	say OUTPUT1 "\n>$num[2]"if ($m!=$num[0]);
	print OUTPUT1 $scaffold{$num[0]}{$num[2]};
	&N100;
	$m=$m+"1" if ($m!=$num[0]);
	say $m;
}

close (INFASTA);
close (INORDER);
close (OUTPUT1);
close (OUTPUT2);






