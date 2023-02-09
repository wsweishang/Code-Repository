#!usr/bin/perl

use strict;
use warnings;

#============================================================================
#Perl正则表达式的一些规范
#============================================================================
#1、定界符
#=~ m/there/;
#=~ s/there/here/;
#还有类型的定界符：
#=~ /there/
#=~ m#there#;
#=~ s#there#here#;
#=~ m(there);
#=~ s(there)(here);
#=~ m{there};
#=~ s{there}{here};
#=~ m[there];
#=~ s[there][here];
#=~ m,there,;
#=~ s,there,here,;
#=~ m.there.;
#=~ s.there.here.;
#=~ m|there|;
#=~ s|there|here|;
#=~ m'there';
#=~ s'there'here';

#2、修改符
#修改符一般放在语句最后一个正斜杠（或者其他分隔符）的后面，修改符还可在匹配范式内定义，这是用(? 修改符)来实现的。
#/x 允许在范式中加上注释和额外的空白字符，以提高程序的可读性。
#/i 允许不分大小写的匹配范式。
#/s 单行方式，决定了圆点 . 是否匹配换行符，使用了/s，圆点就匹配换行符，否则就不匹配。
#比如：
##!/usr/bin/perl
#use strict;
#use warnings;
#my $string = ".\n.";
#print "The original string is: $string\n";
#my $num = $string =~ s|(.)|#|sg;
#print "$num occurences change, and be changed to: $string\n"; exit;
#/m 多行方式，决定了脱字号 ^ 和美圆符 $ 是否匹配换行符，如果不用/s，^和$只能定位在字串的开始和结束处，它们并不匹配嵌入的换行符，这种情况等同于\A和\Z，否则不仅仅匹配字串的开始和结束，也匹配刚好处在嵌入换行符前后的一个位置。
#/o 仅仅一次计算表达式的值
#/e 将替代字符串作为一个表达式（仅仅在替代操作时有效）
#/g 是一个全局修改符。另外，/g与while使用能在字串的所有匹配中进行遍历。修改符/G必须与/g一起使用，用来匹配前一个/g匹配的停止位置。
#如
##!/usr/bin/perl
#use strict;
#use warnings;
#my $string = "~32sda13dAZ.'sDa#!3_C-!";
#print "The original string is: $string\n";
#my $num = $string =~ s.\w.#.g;
#print "$num occurences change, and be changed to: $string\n";
#exit;

#3、正则里一些特殊字符
#() 将表达式结组
#[] 寻找一组字符
#\d 等于 [0-9]
#\D 等于 [^0-9]
#\w 等于 [0-9A-Za-z_]
#\W 等于 [^0-9A-Za-z_]
#\s 等于 [\f\n\r\t ]
#\S 等于 [^\f\n\r\t ]
#. 等于 [^\n]

#4、关于一些特殊符号
#\b 不属于空白字符,向前缩进一个字符
#\t 属于空白字符,匹配制表符
#\r 属于空白字符,匹配回车符
#\a 不属于空白字符,匹配闹钟符
#\e 不属于空白字符,匹配转义符
#\033 不属于空白字符,匹配八进制符
#\x1B 不属于空白字符,匹配十六进制符
#\c[ 不属于空白字符,匹配控制字符
#属于空白字符,匹配空格
#属于空白字符,匹配制表符
#\f 属于空白字符,匹配换页符
#\n 属于空白字符,匹配换行符
#\0 不属于空白字符，功能不详
#\c 不属于空白字符，功能不详
#\x 不属于空白字符，功能不详

#5、注意正则里的选择符的特殊性
#选择运算符是所有运算符中优先级最低的，这意味着它最后执行。

#6、正则里的限定符的一些经典用法
#限定符常常与一些字符或词联合使用
#* 匹配任意数个；
#+ 匹配一个或多个；
#？ 匹配零个或一个；
#{n} 匹配 n 个；
#{n,m} 匹配 n 至 m 个；
#{n,} 匹配 n 和 n 个以上；
#限定符贪婪好像与生俱有的。在缺省状态下，*或+限定符匹配满足正则表达式的一个范式的最大实例数。可用？号显式的规定限定符的不贪婪。如果问号放在另一个限制符之后（甚至另一个问号之后），都可以使限定符不贪婪。

#7、声明与断言
#首先注意声明的长度为 0；
#Perl种有一组控制大小写和换码的声明：
#\u 使下一个字母变大写；
#\l 使下一个字母变小写；
#\U 使文本的剩余字符变成大写；
#\L 使文本的剩余字符变成小写；
#\Q 会除字母之外的其他字符进行换码处理，直至遇到 \E 声明、常规表达式结束或者字串结束。
#\A声明和脱字符号（^）匹配字串的开始；
#\Z声明和美元符号（$）匹配字串的结束或刚好在字串结束前的换行符；
#\z 只匹配字串的结束；
#\b 匹配一个单词（字）边界；
#\B 匹配一个非单词（字）边界；
#(?#text) 忽略括号内的注释文本；
#(?:pattern) 与组一致，但匹配时不生成$1,$2；
#(?imsx:pattern) 与组一致，但匹配时不生成$1,$2，在特定的风格有效期间，内嵌风格匹配修饰符；
#(?=pattern) 前看声明，如果正则表达式在下一次匹配 pattern 风格，就开始匹配，而且不影响匹配效果。如/\w+(?=\t)/将匹配制表符是否恰好在一个字\w+后面出现，并且制表符不添加到$&的值中；
#(?!pattern) 如果正则表达式在后面不匹配 pattern ，才会开始匹配。如/foo(?!bar)/，只有当出现 foo，并且后面不出现 bar 时才开始匹配；
#(? (? (?[code]) 表示对 code 的使用是试验性的。如果返回真，就认为是与(?:pattern)断言同一行里的匹配。code 不插入变量。这个断言仅仅在 use re 'eval' 编译指示符时才有效；
#(?>pattern) 如果类型锁定在当前位置，就使用单独的 pattern 匹配子字符串。如正则表达式/^(?>a*)ab/永远不会匹配，因为语句(?>a*)将匹配字符串开头所有的 a 字符，并删除与 ab 匹配的字符 a；
#(! (!=pattern) 非前看声明，与前看声明意思相反；
#(?(condition)yes-pattern|no-pattern) 条件表达式——条件语句或者是一个圆括号中的整数，或者是一个断言；
#(?(condition)yes-pattern)
#(?imsx) 嵌入风格匹配修饰符。当要把表达式修改符嵌入在变量中，然后把变量用在不指定自己的修饰符的一般规则表达式中；
#(?-imsx) 这个断言很有用——后面带任何内容都会关闭修饰符，直到出现另一个嵌入的修饰符。

#8、向后引用
#Perl的正则表达式引擎允许使用前面匹配好的值，这些值叫做向后引用。
#例如：
#=~ m/(\w)\W*(\w)\W*(\w)\W*(\w)\W*\4\W*\3\W*\2\W*\1/;
#=~ s/(\w)\W*(\w)\W*(\w)\W*(\w)/$4$3$2$1/;




=open&close
#一、打开、关闭文件
#语法为open (filevar, filename)，其中filevar为文件句柄，或者说是程序中用来代表某文件的代号，filename为文件名，其路径可为相对路径，亦可为绝对路径。
#    open(FILE1,"file1");
#    open(FILE1, "/u/jqpublic/file1");
#打开文件时必须决定访问模式，在PERL中有三种访问模式：读、写和添加。后两种模式的区别在于写模式将原文件覆盖，原有内容丢失，形式为open(outfile,">outfile");而添加模式则在原文件的末尾处继续添加内容，形式为：open(appendfile, ">>appendfile")。要注意的是，不能对文件同时进行读和写/添加操作。
#   open的返回值用来确定打开文件的操作是否成功，当其成功时返回非零值，失败时返回零，因此可以如下判断：
#    if (open(MYFILE, "myfile")) {
#    # here's what to do if the file opened successfully
#    }
#  当文件打开失败时结束程序：
#    unless (open (MYFILE, "file1")) {
#    die ("cannot open input file file1\n");
#    }
#  亦可用逻辑或操作符表示如下：
#    open (MYFILE, "file1") || die ("Could not open file");
#  当文件操作完毕后，用close(MYFILE); 关闭文件。
#二、读文件
#  语句$line = ;从文件中读取一行数据存储到简单变量$line中并把文件指针向后移动一行。为标准输入文件，通常为键盘输入，不需要打开。
#  语句@array = ;把文件的全部内容读入数组@array，文件的每一行(含回车符)为@array的一个元素。
#三、写文件
#    形式为：
#    open(OUTFILE, ">outfile");
#    print OUTFILE ("Here is an output line.\n");
#    注：STDOUT、STDERR为标准输出和标准错误文件，通常为屏幕，且不需要打开。
#四、判断文件状态
#    1、文件测试操作符
#    语法为：-op expr，如：
#    if (-e "/path/file1") {
#    print STDERR ("File file1 exists.\n");
#    }
#
# 
#
#文件测试操作符
#
#操作符	描述
#-b	是否为块设备
#-c	是否为字符设备
#-d	是否为目录
#-e	是否存在
#-f	是否为普通文件
#-g	是否设置了setgid位
#-k	是否设置了sticky位
#-l	是否为符号链接
#-o	是否拥有该文件
#-p	是否为管道
#-r	是否可读
#-s	是否非空
#-t	是否表示终端
#-u	是否设置了setuid位
#-w	是否可写
#-x	是否可执行
#-z	是否为空文件
#-A	距上次访问多长时间
#-B	是否为二进制文件
#-C	距上次访问文件的inode多长时间
#-M	距上次修改多长时间
#-O	是否只为“真正的用户”所拥有
#-R	是否只有“真正的用户”可读
#-S	是否为socket
#-T	是否为文本文件
#-W	是否只有"真正的用户"可写
#-X	是否只有"真正的用户"可执行
#注：“真正的用户”指登录时指定的userid，与当前进程用户ID相对，命令suid可以改变有效用户ID。
#  例：
#    unless (open(INFILE, "infile")) {
#    die ("Input file infile cannot be opened.\n");
#    }
#    if (-e "outfile") {
#    die ("Output file outfile already exists.\n");
#    }
#    unless (open(OUTFILE, ">outfile")) {
#    die ("Output file outfile cannot be opened.\n");
#    }
#  等价于
#    open(INFILE, "infile") && !(-e "outfile") &&
#    open(OUTFILE, ">outfile") || die("Cannot open files\n");
#五、命令行参数
#    象C一样，PERL也有存储命令行参数的数组@ARGV，可以用来分别处理各个命令行参数；与C不同的是，$ARGV[0]是第一个参数，而不是程序名本身。
#    $var = $ARGV[0]; # 第一个参数
#    $numargs = @ARGV; # 参数的个数
#    PERL中，操作符实际上是对数组@ARGV的隐含的引用，其工作原理为：
#1、当PERL解释器第一次看到时，打开以$ARGV[0]为文件名的文件；
#2、执行动作shift(@ARGV); 即把数组@ARGV的元素向前移动一个，其元素数量即减少了一个。
#3、操作符读取在第一步打开的文件中的所有行。
#4、读完后，解释器回到第一步重复。
#  例：
#    @ARGV = ("myfile1", "myfile2"); #实际上由命令行参数赋值
#    while ($line = ) {
#    print ($line);
#    }
#    将把文件myfile1和myfile2的内容打印出来。
#六、打开管道
#    用程序的形式也可以象命令行一样打开和使用管道(ex:ls > tempfile)。如语句open (MYPIPE, "| cat >hello"); 打开一个管道，发送到MYPIPE的输出成为命令"cat >hello"的输入。由于cat命令将显示输入文件的内容，故该语句等价于open(MYPIPE, ">hello"); 用管道发送邮件如下：
#    open (MESSAGE, "| mail dave");
#    print MESSAGE ("Hi, Dave! Your Perl program sent this!\n");
#    close (MESSAGE);
=cut







