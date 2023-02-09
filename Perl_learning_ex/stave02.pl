#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my $num=150;
if ($num>100 and $num<200){   #if可以复合判断，中间用and连接
	say "ok";
}

if ($num>100 && $num<200){   #&&和and效果一样
	say "ok";
}

if ($num<100 or $num>200){   #or表示或，满足一个条件就为真
	say "ok";
}

if ($num<100 || $num>200){   #||和or效果一样
	say "ok";
}

if ($num<100 || ($num<200 && $num>100)){   #可以复合判断添加多个条件，最好加上括号，使条例更加清晰
	say "ok";
}