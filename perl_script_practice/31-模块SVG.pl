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
my $height=800;#这儿是画布变量，真是画布可以加大，这儿只是为了方便下面是使用
 
my $svg=SVG->new('width',($width+100),'height',($height+100));
 
my $x=$svg->group(id=>'group_x',style=>{stroke=>'black','stroke-width',1});
my $y=$svg->group(id=>'group_y',style=>{stroke=>'blue','stroke-width',0.5});
my $z=$svg->group(id=>'group_z',style=>{stroke=>'red','stroke-width',0.5});
my $p=$svg->group(id=>'group_p',style=>{stroke=>'purple','stroke-width',0.1});
$x->line(x1=>100,y1=>($height-100), x2=>($width-100), y2=>($height-100));#x轴
$x->line(x1=>100,y1=>($height-100),x2=>100,y2=>100);#y轴
 
$x->line(x1=>100,y1=>100,x2=>95,y2=>105);
$x->line(x1=>100,y1=>100,x2=>105,y2=>105);#y轴的两个箭头
$x->line(x1=>($width-100),y1=>($height-100),x2=>($width-105),y2=>($height-105));
$x->line(x1=>($width-100),y1=>($height-100),x2=>($width-105),y2=>($height-95));#x轴的两个箭头
 
$svg->text(x=>90,y=>$height-90,'font-size'=>10,'stroke','black','-cdata',"0");#0点
$svg->text(x=>90,y=>100,'font-size'=>10,'stroke','black','-cdata',"y");
$svg->text(x=>($width-100),y=>$height-90,'font-size'=>10,'stroke','black','-cdata',"x");#x和y两个小标
 
my $sw=($width-200)/10;#轴长标度
my $sh=($height-200)/10;
 
 
my $k=();
for($k=1; $k <10; $k++){
$x->line(x1=>(100+$sw*$k), y1=>($height-100), x2=>(100+$sw*$k), y2=>($height-95) );#y轴刻度
$x->line(x1=>100, y1=>($height-100-$sh*$k), x2=>95, y2=>($height-100-$sh*$k) );#x轴刻度
$p->line(x1=>(100+$sw*$k), y1=>($height-100), x2=>(100+$sw*$k), y2=>100 );
$p->line(x1=>100, y1=>($height-100-$sh*$k), x2=>($width-100), y2=>($height-100-$sh*$k) );#网格线
}
 
my $value_y = 0.1;
#my $value_x;
for($k=1; $k<10; $k++){
#$svg->text(x=>(100+$sw*$k), y=>($height-100), 'font-size'=>18, 'stroke', 'black', 'font-weight'=>'bold', '-cdata', $temp );
$svg->text(x=>70, y=>($height-100-$sh*$k), 'font-size'=>10, 'stroke', 'black', '-cdata', $value_y*$k/10 );#刻度值
}
 
my $Line = scalar( @theta );
my $mx = ($width - 200) / $Line;
my $my = ($height - 200) / 0.1;
 
#print STDERR "$Line\n";
for (my $k=1; $k<$Line; $k++){
        $y->line(x1=>(100+$mx*($k-1)), y1=>($height-100-$my*$theta[$k-1]), x2=>(100+$mx*$k), y2=>($height-100-$my*$theta[$k]),'stroke','orange','fill','orange' );
        $z->line(x1=>(100+$mx*($k-1)), y1=>($height-100-$my*$fst[$k-1]), x2=>(100+$mx*$k), y2=>($height-100-$my*$fst[$k]),'stroke','pink','fill','pink');#作图，注意是划线，不是标点
}
#print "$line\n";
 
print $svg->xmlify;


#=================================================================================================
#!usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
#use GD::Graph::Data;#设置数据封装
#use Encode;#用于处理汉字问题
#use GD::Graph::lines;  #创建折线图
#use GD::Graph::bars; #垂直柱状图
#use GD::Graph::hbars; #水平柱状图
#use GD::Graph::points;  #点状图
#use GD::Graph::linespoints; #折线图，但是数据部分用点显示
#use GD::Graph::pie; #饼图

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
	my $graph= GD::Graph::pie->new(600, 300);#设置坐标轴的宽度
	$graph->set(
	x_label           => 'Years' ,  #X轴标签
	y_label           => 'Number',  #Y轴标签
	title             => 'Number of publications retrieved from ISI cccc',#图的标题
           
           y_max_value       =>300, #Ｙ轴最大值
           y_tick_number     =>5,  #Y轴坐标的个数
         
         transparent => 0,      #背景是否透明
         
         axislabelclr=>'red',     
         
         long_ticks => 1,          #是否显示长刻度线
         x_ticks  => 0,       #X轴不显示长刻度线
         #dclrs =>[qw(green red blue black)],  # 设定饼图片颜色，如果不设定则默认自动分配,最好是自动分配          
        );
     
  open(IMG, '>file.png') or die $!;
  binmode IMG;
  print IMG $graph->plot(\@array) ->png;
  close IMG;
}











