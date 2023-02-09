## .pl <a file that contains a scaffold's all gene information in gff3 format>

use strict;
use autodie;

my $gff_file = $ARGV[0];
my %gff_save;
my $geneid;
my $a_gene_line;
my $check = 'appeared';
my $outer_orient;

open (GFF,"<$gff_file") or die "$!";
while (my $gff_line = <GFF>){
	my ($type,$start,$end,$orient) = (split /\t/,$gff_line)[2,3,4,6];
	if($type eq 'gene'){
		if($check eq 'not_appeared'){
			$gff_save{$outer_orient}{$geneid} = $a_gene_line;
		}
		$geneid = $start.'_'.$end;
		$outer_orient = $orient;
		$a_gene_line = undef;
		if($gff_save{$outer_orient}{$geneid}){
			$check = 'appeared';
		}else{
			$check = 'not_appeared';
		}
	}
	if($check eq 'not_appeared'){
		$a_gene_line .= $gff_line;
	}
}
close (GFF);
if($check eq 'not_appeared'){
	$gff_save{$outer_orient}{$geneid} = $a_gene_line;
}

my @overlap_geneids;
my @orients = sort{$a<=>$b}keys %gff_save;
foreach my $orient (@orients){
	print "$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient$orient\n";
	my @all_geneid = sort{$a<=>$b}keys %{$gff_save{$orient}};
	OUT: for (my $i=0;$i<$#all_geneid;$i++){
		print '$all_geneid[$i]';print "\t$all_geneid[$i]\n";
		my ($first_s,$first_e) = split /_/,$all_geneid[$i];
		for (my $j=1;$j<=$#all_geneid;$j++){
			print '$all_geneid[$j]';print "\t$all_geneid[$j]\n";
			my ($later_s,$later_e) = split /_/,$all_geneid[$j];
			if(OVERLAP($first_s,$first_e,$later_s,$later_e)){
				push @overlap_geneids,$all_geneid[$j];
				splice (@all_geneid,$j,1);
				$j--;
			}else{
				if(@overlap_geneids){
					unshift @overlap_geneids,$all_geneid[$i];
					splice (@all_geneid,$i,1);
					$i--;
					map{print "^$_\n"}@overlap_geneids;	
					map{print "#$_\n"}@all_geneid;			
					for (my $a=0;$a<=$#overlap_geneids;$a++){
						my ($first_s,$first_e) = split /_/,$overlap_geneids[$a];
						for(my $b=0;$b<=$#all_geneid;$b++){
							my ($later_s,$later_e) = split /_/,$all_geneid[$b];
							if (OVERLAP($first_s,$first_e,$later_s,$later_e)) {
								push @overlap_geneids,$all_geneid[$b];
								splice (@all_geneid,$b,1);
								$b--;
							}
						}
					}
					my $max_length;
					my $max_length_gff;
					my $max_length_geneid;
					foreach my $overlap_geneid (@overlap_geneids){
						my($start,$end) = split /_/,$overlap_geneid;
						my $length = $end-$start+1;
						if($length > $max_length){
							$max_length = $length;
							$max_length_geneid = $overlap_geneid;
							$max_length_gff = $gff_save{$orient}{$max_length_geneid};
						}
					}
					print "_$max_length_gff\n";
					@overlap_geneids = ();
					next OUT;
				}else{
					print "__$gff_save{$orient}{$all_geneid[$i]}\n";
					splice (@all_geneid,$i,1);
					$i--;
					next OUT;
				}
			}
		}
	}
}

sub OVERLAP {
        my ($start_1,$end_1,$start_2,$end_2) = @_;
        my $length_1 = $end_1 - $start_1 +1;
        my $length_2 = $end_2 - $start_2 +1;
        my $half_1 = $length_1 *1/2 + $start_1;
        my $half_2 = $length_2 *1/2 + $start_2;
        my $distance = $half_1 - $half_2;
        if ($distance < 0) {$distance *= -1}
        if (($length_1 + $length_2)*1/2 < $distance) {
        	return 0;
        }else{
                return 1; ##overlaped;
        }
}
