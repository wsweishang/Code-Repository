#!/perl/bin/perl

@array = (1,2,3);
$array[50] = 50;
$size = @array;
$max_index = $#array;
print pop(@array);
print "数组大小: $size\n";
print "最大索引: $max_index\n";

