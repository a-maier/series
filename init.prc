#procedure init(CUT)

#$maxtermnum=`CUT';
#$labelnum=0;
S [:x],[:y],[:i];
cf [:exp],[:log],[:den],[:LOG],[:EXP];
cf exp,log,D,[:f];

table [:b](0:`CUT');
#do n=0,`CUT'
   #$b`n'=0;
   fill [:b](`n')=$b`n';
#enddo

#endprocedure
