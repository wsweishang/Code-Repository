#!/usr/bin/perl

=cut
Copyright 2017, Hyunchul Park <hcpark79@korea.kr> and Eu-Ree Ahn(sweater@korea.kr)

* CpG Island Predictor and Primer (CpGPNP)

CpGPredictor-2.4.pl - Predict CpG Islands from fasta file

CpGPNP is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

=head1 SYNOPSIS

#17.6.28? ?? 
#17.8.8 ? ?? (improve search sensitivity)
#17.8.17 ? ?? 


=cut

use Getopt::Long;

# set the parameter
my $usage = "\nUsage: perl $0 -f INPUTFILE[FASTA] (-l INT -w INT -m STRING -g INT -o INT) -fa yes(or y) -s OUTPUTFILE\n".
				"\t -f[--file] : INPUT file (FASTA format)\n".
				"\t -l[--searchlength] : Length of CpG island, [default 500]\n".
				"\t -w[--slide] : moving window, [default 1]\n".
				"\t -m[--motif] : motif which user searches [X: all character] \n".
				"\t -g[--GC] : Threshold of GC contents percent, [default 55]\n".
				"\t -o[--OBEX] : Threshold of Observed /Expected CpG Ratio, [default 0.65]\n".
				"\t -fa : make FASTA file, [y or yes; default No] \n".
				"\t -s[--save] : OUTPUT file (.txt)\n";

if (scalar @ARGV==0) {
	die $usage;
}
my $seqlength = 500;
my $slideWindow = 1;
my $gc = 55;
my $obex = 0.65;
my $motif = "CG";
my ($file, $save, $fasta);
my $options = GetOptions("file|f=s" => \$file,
								 "searchlength|l=i" => \$seqlength,
								 "slide|w=i" => \$slideWindow,
								 "motif|m=s" => \$motif,
								 "GC|g=i"=> \$gc,
								 "OBEX|o=f" => \$obex,
								 "fasta|fa=s" => \$fasta,
								 "save|s=s" => \$save);
						
open(FH,$file) || die "cannot open $file for reading: $!";
@files = <FH>;
chomp @files;

$motif =~ s/X/[A-Z]/g; 
$searchlength = $seqlength;
# Check header of FASTA File
if ($files[0] =~ "^>"){
	for($i=1;$i<=$#files;$i++){
		push(@reAssemble, $files[$i]);
	}
}else{
	for($i=0;$i<=$#files;$i++){
		push(@reAssemble, $files[$i]);
	}
}
#system "mkdir $save";
# Save result files
open(OUT,">$save.rawdata") || die "cannot create $b: $!";
open(RESULT,">$save".".groups");
open(CONFIG, ">$save".".summary");
open(CONTIG, ">$save".".contig");
open(RGRAPH, ">$save".".graph");
if ($fasta eq "y" or $fasta eq "yes"){
	open(FASTA, ">$save".".fasta");
}

# split DNA seqeunces into 1 digit character
$temp = join("",@reAssemble);
@seq = split("",$temp);

# setup initial parameters
$first = 0; # start position
$countOfCG = 0; # CpG dimer initialization
$resultTotal = 1; # result

# header of .TXT FILE
print OUT "Start_Pos. \t Last_Pos. \t No_of_C \t No_of_G \t No_of_CpG \t GC_contents(%) \t Obs_CpG \t Exp_CpG \t obs/exp_CpG_ratio \t Length \t slideWindow \t Sequence \n";
print RGRAPH "Start_Pos. \t Last_Pos. \t No_of_C \t No_of_G \t No_of_CpG \t GC_contents(%) \t Obs_CpG \t Exp_CpG \t obs/exp_CpG_ratio \t Length \t slideWindow \t Sequence \n";
$threshold_of_CG = ($seqlength*$obex)/16;
#################### START OF sliding-window and heuristic-search ####################
print "............... Calculating ................. \n";
do {
	$last = $first+($seqlength-1); # last position
	@slide = @seq[$first..$last]; # range of searching window
	chomp(@slide);
	
	&calculation(@slide); # subroutine for calculation
	print RGRAPH $first+1,"\t",$last+1,"\t $countOfC \t $countOfG \t $countOfCG \t $GC_content \t $ObservedCpG \t $ExpectedCpG \t $ggf \t $seqlength \t $slideWindow \t $window \n";
	if ($countOfCG >= $threshold_of_CG){
		if ($GC_content>= $gc && $ggf>= $obex) {
			# make array the first and last position for groups
		    push(@startPos,$first);
			push(@lastPos,$last);

			# .TXT FILE
			print OUT $first+1,"\t",$last+1,"\t $countOfC \t $countOfG \t $countOfCG \t $GC_content \t $ObservedCpG \t $ExpectedCpG \t $ggf \t $seqlength \t $slideWindow \t $window \n";
			$resultTotal++; # increase the number of result
		}
	}
	$first=$first+$slideWindow; # increase first posion for $slideWindow
}until $last >= $#seq+1;
#################### END OF sliding-window and heuristic-search ####################

############################### Grouping START #################################################
&grouping(\@startPos,\@lastPos); # subroutine for grouping from 1st results
$numberOfgroup= $#groupStartPos+1;
print RESULT "START \t LAST \t Length \t GC% \t Obs/Exp Ratio \t SEQEUNCE \n";
for ($j=0;$j<=$#groupStartPos;$j++) {
	@group_sequence = @seq[$groupStartPos[$j]..$groupLastPos[$j]];
	chomp (@group_sequence);
	$seqlength = @group_sequence;
	&calculation(@group_sequence); # re-calculate GC_contents and o/e ratio from group result file

	# check criteria
	if ($GC_content >= $gc && $ggf >= $obex) {
		print RESULT $groupStartPos[$j]+1,"\t",$groupLastPos[$j]+1,"\t $seqlength \t $GC_content \t $ggf \t ",@group_sequence,"\n"; # .GROUPS FILE
		push (@contigStart,$groupStartPos[$j]); # make array the first and last position of groups file for making contig 
		push (@contigEnd,$groupLastPos[$j]);
	}
}
###### Modify CpGPredictor-2.4.pl #####
	if ($temp == 2) {
	@group_sequence = @seq[$lastLine[0]..$lastLine[1]];
	chomp (@group_sequence);
	$seqlength = ($lastLine[1]-$lastLine[0])+1;
	&calculation(@group_sequence);
		if ($GC_content >= $gc && $ggf >= $obex) {
		print RESULT $lastLine[0]+1, "\t",$lastLine[1]+1,"\t","$seqlength \t $GC_content \t $ggf \t ",@group_sequence,"\n";
		push (@contigStart,$lastLine[0]);
		push (@contigEnd,$lastLine[1]);
		$numberOfgroup= ($#groupStartPos+$#lastLine)+1;
		}
	}

############################### Grouping END ################################################# 

############################### Contig START ################################################# 
print "\n............. CpG Island Contigs .................\n\n";
&contig(\@contigStart,\@contigEnd);
$cnt = 0;
print "No. \t START \t LAST \t Length \t GC_Contents \t obs/exp_CpG_ratio \n";
print CONTIG "START \t LAST \t Length \t GC_Contents \t obs/exp_CpG_ratio \t SEQEUNCE \n";
for ($j=0;$j<=$#contigStartPos;$j++) {
	@contig_sequence = @seq[$contigStartPos[$j]..$contigLastPos[$j]];
	chomp (@contig_sequence);
	$seqlength = @contig_sequence;

	&calculation(@contig_sequence);
	$result_sequence=join("",@contig_sequence);
	if ($GC_content >= $gc && $ggf >= $obex) {
		$cnt++;
		print "$cnt \t",$contigStartPos[$j]+1,"\t",$contigLastPos[$j]+1,"\t $seqlength \t $GC_content \t $ggf \n";
		# .CONTIG FILE
		print CONTIG $contigStartPos[$j]+1,"\t",$contigLastPos[$j]+1,"\t $seqlength \t $GC_content \t $ggf \t",$result_sequence,"\n";
		# .fasta FILE
		if ($fasta eq "y" or $fasta eq "yes"){
			print FASTA ">CpG[$cnt]",$contigStartPos[$j]+1,"-",$contigLastPos[$j]+1,"_",$seqlength,"\n";
			print FASTA $result_sequence,"\n\n";
		}
		$numberOfcontig = $#contigStartPos;
	}
	###### ADD CpGPredictor-2.3.pl #####
	if ($GC_content < $gc || $ggf < $obex) { # below the threshold (add the function 17.7.31)
		$cnt++;
		$forward =  $contigStartPos[$j];
		$backward = $contigLastPos[$j];
		$diff= ($contigLastPos[$j] - $contigStartPos[$j])/2;
		for ($k=0;$k<=$diff;$k++){ # trim left end sequence 1nt 
			@newContig = @seq[$forward+$k..$backward]; # trim end sequence 1nt , forward + 1 
			chomp(@newContig);
			$newSeqLength = @newContig;
			&calculation(@newContig);
			#print "$cnt \t",$forward+$k+1,"\t",$backward-$k+1,"\t $newSeqLength \t $GC_content \t $ggf \n";
			if ($GC_content >= $gc && $ggf >= $obex){
				print "$cnt \t",$forward+$k+1,"\t",$backward-$k+1,"\t $newSeqLength \t $GC_content \t $ggf \n";
				print CONTIG $forward+$k+1,"\t",$backward-$k+1,"\t $newSeqLength \t $GC_content \t $ggf \t",@newContig, "\n";
				
				if ($fasta eq "y" or $fasta eq "yes"){
					print FASTA ">CpG[$cnt]",$forward+$k+1,"-",$backward-$k+1,"_",$newSeqLength,"\n";
					print FASTA @newContig,"\n\n";
				}
				last;
			}
		}
	}
}

################################### .SET FILE ###################################
print CONFIG "\n*SUMMARY* \n";
print CONFIG "Total Sequence Length of $file: ",$#seq+1,"\n";
print CONFIG "Number of CpG Island rawdata of $file: ", $resultTotal-1,"\n";
print CONFIG "Number of CpG Island group: ", $numberOfgroup,"\n";
print CONFIG "Number of CpG Island contig: ", $cnt,"\n";
print CONFIG "\nSetting parameter \n";
print CONFIG "Searching Range of CpG Island : ",$searchlength,"\n";
print CONFIG "Sliding-Window Interval of basepair : ",$slideWindow,"\n";
print CONFIG "Threshold of GC Contentes : ",$gc,"\n";
print CONFIG "Threshold of observed-to-expected CpG ratio : ",$obex,"\n";
close(CONFIG);
############################### Contig END ################################################# 

sub calculation {
	$countOfCG = 0;
	$ggf = 0;
	$GC_content = 0;
	$countOfC = 0;
	$countOfG = 0;
	$window=join("",@_); # join array into scalar
	$seqlength= length($window);
	if ($window=~/$motif/i){
		$window =~ tr/A-Z/a-z/; # transform Uppercase to Lowcase of DNA sequence
		# counting the C, G, and CG dimer
		$countOfC = $window =~ tr/c//; # count C within window of sequence
		$countOfG = $window =~ tr/g//; # count G within window of sequence
		while ($window =~ /cg/g) {$countOfCG++;} # count CG dimer within window of sequence
		# Calculation 
		$GC_content = (($countOfC+$countOfG)/$seqlength)*100; # GC contents (percent)
		$ExpectedCpG = ($countOfC * $countOfG)/$seqlength;
		$ObservedCpG = $countOfCG; # number of CpGs
		if ($countOfCG eq 0 || $ExpectedCpG eq 0) {
			$ggf = 0;		
		}
		else{
			$ggf = ($countOfCG / ($countOfC * $countOfG))*$seqlength;
			#$ggf = ((abs($ggf)/0.001)+0.5)*0.001;
			$ggf = ((abs($ggf)/0.01)+0.5)*0.01;
		}
		return $window, $countOfC, $countOfG, $countOfCG, $GC_content, $ExpectedCpG, $ObservedCpG, $ggf;
	}
}

sub grouping {
	($one, $two)=@_;
	@startPos=@{$one};
	@lastPos=@{$two};

	$count=1;
	$temp=0;
	$single=-1;
	for($i=0;$i<=$#startPos;$i++){
		if ($startPos[$i] == $startPos[$i+1]-$slideWindow) {
			$count++;
		}		
		elsif ($startPos[$i] != $startPos[$i+1]-$slideWindow && $startPos[$i+1] ne "") {
			$count=1; 
		}elsif ($startPos[$i] != $startPos[$i+1]-$slideWindow && $startPos[$i+1] eq "") {
			$count=0;
		}

				
		if ($count==2) {
			push(@groupStartPos,$startPos[$i]);
		}
		if ($count==1){	
			$single++;	
			if ($groupStartPos[$single] eq undef){
				push(@groupLastPos,$lastPos[$i]);
				push(@groupStartPos,$startPos[$i]);
			}elsif ($groupStartPos[$single] ne undef) {
				push(@groupLastPos,$lastPos[$i]);
			}	
		}
		if ($count==0) {
			if ($startPos[$i]-$startPos[$i-1] == $slideWindow) {
				#$temp = 2;
				push (@groupLastPos,$lastPos[$i]);
			}elsif ($startPos[$i]-$startPos[$i-1] != $slideWindow){
				$temp = 2;
				push (@lastLine, $startPos[$i], $lastPos[$i]);
			}
		}
	}
	return @groupStartPos, @groupLastPos, @lastLine;
}

sub contig {
	($one, $two)=@_;
	@startPos=@{$one};
	@lastPos=@{$two};

	$count=1;
	$temp=0;
	$single=-1;
	for($i=0;$i<=$#startPos;$i++){
		if ($startPos[$i+1] <= $lastPos[$i] && $lastPos[$i] <= $lastPos[$i+1]) {
			$count++;
		}		
		elsif ($startPos[$i+1] > $lastPos[$i] && $startPos[$i+1] ne "") {
			$count=1; 
		}elsif ($startPos[$i+1] eq "") {
			$count=0;
		}
		
		if ($count==2) {
			push(@contigStartPos,$startPos[$i]);
		}
		if ($count==1){	
			$single++;	
			if ($contigStartPos[$single] eq undef){
				push(@contigLastPos,$lastPos[$i]);
				push(@contigStartPos,$startPos[$i]);
			}elsif (@contigStartPos[$single] ne undef) {
				push(@contigLastPos,$lastPos[$i]);
			}	
		}
		if ($count==0) {
				push (@contigStartPos,$startPos[$i]); ###### ADD CpGPredictor-2.4.pl 
				push (@contigLastPos,$lastPos[$i]);

		}
	}
	return @contigStartPos, @contigLastPos;
}
