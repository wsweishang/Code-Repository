##use Hash::Merge qw( merge );
#my %a = ( 
#        'foo'    => 1,
#        'bar'    => [ qw( a b e ) ],
#        'querty' => { 'bob' => 'alice' },
#    );
#my %b = ( 
#            'foo'     => 2, 
#            'bar'    => [ qw(c d) ],
#            'querty' => { 'ted' => 'margeret' }, 
#    );
# 
#my %c = %{ merge( \%a, \%b ) };
# 
#Hash::Merge::set_behavior( 'RIGHT_PRECEDENT' );
# 
## This is the same as above
# 
#    Hash::Merge::specify_behavior(
#        {
#                    'SCALAR' => {
#                            'SCALAR' => sub { $_[1] },
#                            'ARRAY'  => sub { [ $_[0], @{$_[1]} ] },
#                            'HASH'   => sub { $_[1] },
#                    },
#                    'ARRAY => {
#                            'SCALAR' => sub { $_[1] },
#                            'ARRAY'  => sub { [ @{$_[0]}, @{$_[1]} ] },
#                            'HASH'   => sub { $_[1] }, 
#                    },
#                    'HASH' => {
#                            'SCALAR' => sub { $_[1] },
#                            'ARRAY'  => sub { [ values %{$_[0]}, @{$_[1]} ] },
#                            'HASH'   => sub { Hash::Merge::_merge_hashes( $_[0], $_[1] ) }, 
#                    },
#            }, 
#            'My Behavior', 
#    );
#     
##Also there is OO interface.
# 
#my $merge = Hash::Merge->new( 'LEFT_PRECEDENT' );
#my %c = %{ $merge->merge( \%a, \%b ) };
# 
##All behavioral changes (e.g. $merge->set_behavior(...)), called on an object remain specific to that object
##The legacy "Global Setting" behavior is respected only when new called as a non-OO function.


use Data::Dumper;
#-----------------------------
%merged = (%A, %B);
#-----------------------------
%merged = ();
while ( ($k,$v) = each(%A) ) {
    $merged{$k} = $v;
}
while ( ($k,$v) = each(%B) ) {
    $merged{$k} = $v;
}
#-----------------------------
# %food_color as per the introduction
%food_color = ( Galliano  => "yellow",
                 "Mai Tai" => "blue" );
 
#%ingested_color = (%drink_color, %food_color);
#-----------------------------
# %food_color per the introduction, then
%drink_color = ( Galliano1  => "yellow",
                 "Mai Tai1" => "blue" );
%substance_color = ();
while (($k, $v) = each %food_color) {
    $substance_color{$k} = $v;
}
while (($k, $v) = each %drink_color) {
    $substance_color{$k} = $v;
}
print Data::Dumper->Dumper(\%substance_color);
print "\n";
#-----------------------------
foreach $substanceref ( \%food_color, \%drink_color ) {
    while (($k, $v) = each %$substanceref) {
        $substance_color{$k} = $v;
    }
}
#-----------------------------
foreach $substanceref ( \%food_color, \%drink_color ) {
    while (($k, $v) = each %$substanceref) {
        if (exists $substance_color{$k}) {
            print "Warning: $k seen twice.  Using the first definition.\n";
            next;
        }
        $substance_color{$k} = $v;
    }
}
#-----------------------------
#@all_colors{keys %new_colors} = values %new_colors;
#-----------------------------
#Êä³ö£º
#$VAR1 = 'Data::Dumper';
#$VAR2 = {
#          'Mai Tai1' => 'blue',
#          'Mai Tai' => 'blue',
#          'Galliano1' => 'yellow',
#          'Galliano' => 'yellow'
#        };
#Warning: Galliano seen twice.  Using the first definition.
#Warning: Mai Tai seen twice.  Using the first definition.
#Warning: Galliano1 seen twice.  Using the first definition.
#Warning: Mai Tai1 seen twice.  Using the first definition.
















