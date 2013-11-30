#!/usr/bin/perl - w

use strict;
use warnings; 

my @ar = ("A", "A#", "B", "C", "C#", "D", "D#", "E","F","F#", "G", "G#");
my $count = 0;

print join ", ", @ar;

for my $i (21..108) 
{
    my $note = shift @ar;
    
    if ($note =~/C/ && !($note =~/#/)){ $count++;  }
    
    if($note =~/"#"/) {
	$note =~ s/#//g;
	print $note."#$count $i\n";
    }else { 
	print $note.$count." $i\n";
    }
    
    push(@ar, $note);

}
