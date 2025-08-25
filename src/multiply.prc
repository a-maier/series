#procedure multiply(SOURCE1,SOURCE2,TARGET)
*multiplys the expressions SOURCE1 and SOURCE2 and saves the result in TARGET

   #call toseries(`SOURCE1',ta)
   #call toseries(`SOURCE2',tb)
   #define CUT "`$cut'"
   #define MINPOW "{`$minpowerta'+`$minpowertb'}"
   S [:x],[:y];
*  #call createtable(tc,{`CUT'-`MINPOW'})
   skip;
*  use Cauchy multiplication
   L `TARGET'=
   sum_([:x],`MINPOW',`CUT',
   sum_([:y],0,[:x]-`MINPOW',
   [:ta]([:y])*[:tb]([:x]-[:y])
   )
   );
*    #do n=`MINPOW',`CUT'
*       +(
*       #do i=0,{`n'-`MINPOW'}
* 	 +[:ta](`i')*[:tb]({`n'-`i'})
*       #enddo
*       )*`$var'^`n'
*    #enddo
*    ;
   if(count([:ta],1,[:tb],1)>0)discard;
   .sort
   cleartable [:ta];
   cleartable [:tb];
*  cleartable [:tc];

#endprocedure
