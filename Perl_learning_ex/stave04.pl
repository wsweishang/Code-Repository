#!/perl/bin/perl

@array = (1,2,3);
$array[50] = 50;
$size = @array;
$max_index = $#array;
print pop(@array);
print "�����С: $size\n";
print "�������: $max_index\n";

