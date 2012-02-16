#procedure init(CUT)


#$maxtermnum=`CUT';
#do n=0,`CUT'
   #$a`n'=0;
#enddo

.sort
S [:x],[:y],[:i];
cf [:exp],[:log],[:den],[:LOG],[:EXP];
cf exp,log,D;
f [:d],[:f];

*coefficients of original function
table [:a](0:`CUT');
#do n=0,`CUT'
   fill [:a](`n')=$a`n';
#enddo

*coefficients of expanded functions
table [:b_inverse](0:`CUT');
fill [:b_inverse](0)=1;
#do n=1,`CUT'
   fill [:b_inverse](`n')=
   #do i=0,{`n'-1}
      - [:a]({`n'-`i'})*[:b_inverse](`i')
   #enddo
   ;
#enddo

table [:b_log](1:`CUT');
#do n=1,`CUT'
   fill [:b_log](`n')=[:a](`n')
   #do i=1,{`n'-1}
      - (`i')/(`n')*[:a]({`n'-`i'})*[:b_log](`i')
   #enddo
   ;
#enddo

table [:b_f](0:`CUT');
fill [:b_f](0)=[:f]( [:a](0) );
#do n=1,`CUT'
   fill [:b_f](`n')=
   #do i=1,`n'
       + [:d](0)*(`i')/(`n')*[:a](`i')*[:b_f]({`n'-`i'})
   #enddo
   ;
#enddo

skip;
.sort



#endprocedure
