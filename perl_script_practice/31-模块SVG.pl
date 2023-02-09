#!/usr/bin/perl

use strict;
use warnings;
#use SVG;
 
my $infile = shift;
open (AA,"<$infile") or die "$!";
my @theta=();
my @fst=();
my $aa=();
while ($aa=<AA>){
	my @t=split (/\t/,$aa);
	push (@theta,$t[0]);
	push (@fst,$t[1]);
}
close (AA);
 
my $width=800;
my $height=800;#����ǻ������������ǻ������ԼӴ����ֻ��Ϊ�˷���������ʹ��
 
my $svg=SVG->new('width',($width+100),'height',($height+100));
 
my $x=$svg->group(id=>'group_x',style=>{stroke=>'black','stroke-width',1});
my $y=$svg->group(id=>'group_y',style=>{stroke=>'blue','stroke-width',0.5});
my $z=$svg->group(id=>'group_z',style=>{stroke=>'red','stroke-width',0.5});
my $p=$svg->group(id=>'group_p',style=>{stroke=>'purple','stroke-width',0.1});
$x->line(x1=>100,y1=>($height-100), x2=>($width-100), y2=>($height-100));#x��
$x->line(x1=>100,y1=>($height-100),x2=>100,y2=>100);#y��
 
$x->line(x1=>100,y1=>100,x2=>95,y2=>105);
$x->line(x1=>100,y1=>100,x2=>105,y2=>105);#y���������ͷ
$x->line(x1=>($width-100),y1=>($height-100),x2=>($width-105),y2=>($height-105));
$x->line(x1=>($width-100),y1=>($height-100),x2=>($width-105),y2=>($height-95));#x���������ͷ
 
$svg->text(x=>90,y=>$height-90,'font-size'=>10,'stroke','black','-cdata',"0");#0��
$svg->text(x=>90,y=>100,'font-size'=>10,'stroke','black','-cdata',"y");
$svg->text(x=>($width-100),y=>$height-90,'font-size'=>10,'stroke','black','-cdata',"x");#x��y����С��
 
my $sw=($width-200)/10;#�᳤���
my $sh=($height-200)/10;
 
 
my $k=();
for($k=1; $k <10; $k++){
$x->line(x1=>(100+$sw*$k), y1=>($height-100), x2=>(100+$sw*$k), y2=>($height-95) );#y��̶�
$x->line(x1=>100, y1=>($height-100-$sh*$k), x2=>95, y2=>($height-100-$sh*$k) );#x��̶�
$p->line(x1=>(100+$sw*$k), y1=>($height-100), x2=>(100+$sw*$k), y2=>100 );
$p->line(x1=>100, y1=>($height-100-$sh*$k), x2=>($width-100), y2=>($height-100-$sh*$k) );#������
}
 
my $value_y = 0.1;
#my $value_x;
for($k=1; $k<10; $k++){
#$svg->text(x=>(100+$sw*$k), y=>($height-100), 'font-size'=>18, 'stroke', 'black', 'font-weight'=>'bold', '-cdata', $temp );
$svg->text(x=>70, y=>($height-100-$sh*$k), 'font-size'=>10, 'stroke', 'black', '-cdata', $value_y*$k/10 );#�̶�ֵ
}
 
my $Line = scalar( @theta );
my $mx = ($width - 200) / $Line;
my $my = ($height - 200) / 0.1;
 
#print STDERR "$Line\n";
for (my $k=1; $k<$Line; $k++){
        $y->line(x1=>(100+$mx*($k-1)), y1=>($height-100-$my*$theta[$k-1]), x2=>(100+$mx*$k), y2=>($height-100-$my*$theta[$k]),'stroke','orange','fill','orange' );
        $z->line(x1=>(100+$mx*($k-1)), y1=>($height-100-$my*$fst[$k-1]), x2=>(100+$mx*$k), y2=>($height-100-$my*$fst[$k]),'stroke','pink','fill','pink');#��ͼ��ע���ǻ��ߣ����Ǳ��
}
#print "$line\n";
 
print $svg->xmlify;


#=================================================================================================
#!usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
#use GD::Graph::Data;#�������ݷ�װ
#use Encode;#���ڴ���������
#use GD::Graph::lines;  #��������ͼ
#use GD::Graph::bars; #��ֱ��״ͼ
#use GD::Graph::hbars; #ˮƽ��״ͼ
#use GD::Graph::points;  #��״ͼ
#use GD::Graph::linespoints; #����ͼ���������ݲ����õ���ʾ
#use GD::Graph::pie; #��ͼ

my ($Lines,$Points,$Bars,$Linespoints,$Pie,$Hbars);
my %opts;

GetOptions(
	\%opts,
	"lines:s"=>\$Lines,
	"points:s"=>\$Points,
	"bars:s"=>\$Bars,
	"linespoints:s"=>\$Linespoints,
	"pie:s"=>\$Pie,
	"hbars:s"=>\$Hbars
);
$infile=shift;
open(FILE,"$infile");
#my @data=[(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35)];
my @data=[(2002,2003,2004,2005,2006,2007,2008,2009,2010)];
my @array;
push @array, @data;

while(<FILE>)
{
 if ($_!~/\>/)
 {
  
  my @name=split;
   push @array,[@name];
  }
   
}

&bars if defined $Bars;
&hbars if defined $Hbars;
&lines if defined $Lines;
&linespoints if defined $Linespoints;
&pie if defined $Pie;
&points if defined $Points;
 
sub pie{
	my $graph= GD::Graph::pie->new(600, 300);#����������Ŀ��
	$graph->set(
	x_label           => 'Years' ,  #X���ǩ
	y_label           => 'Number',  #Y���ǩ
	title             => 'Number of publications retrieved from ISI cccc',#ͼ�ı���
           
           y_max_value       =>300, #�������ֵ
           y_tick_number     =>5,  #Y������ĸ���
         
         transparent => 0,      #�����Ƿ�͸��
         
         axislabelclr=>'red',     
         
         long_ticks => 1,          #�Ƿ���ʾ���̶���
         x_ticks  => 0,       #X�᲻��ʾ���̶���
         #dclrs =>[qw(green red blue black)],  # �趨��ͼƬ��ɫ��������趨��Ĭ���Զ�����,������Զ�����          
        );
     
  open(IMG, '>file.png') or die $!;
  binmode IMG;
  print IMG $graph->plot(\@array) ->png;
  close IMG;
}











