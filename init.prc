#procedure init(CUT)

#$maxtermnum=`CUT';
#$labelnum=0;
S [:x],[:y],[:i];
cf [:exp],[:log],[:den],[:LOG],[:EXP];
cf exp,log,D,[:f];

table [:b](0:`CUT');
#do n=0,`CUT'
   #$a`n'=0;
   #$b`n'=0;
   fill [:b](`n')=$b`n';
#enddo

*just for convenience and to suppress warnings
#$minterm=0;
#$invminterm=0;
#$minpow=0;
#$c=0;
#$lim=0;
#$x=0;
#$t=0;
#$sum=0;

#endprocedure
