#procedure powerfunction(POW,?SERIESSPEC)
*replaces `POW'(x,y) by x^y, treating both x and y as series (as specified by the procedure series)

*uses `POW'(x,y)=exp(y*log(x))

   #ifdef `?SERIESSPEC'
      #do ARG={`?SERIESSPEC'}
	 #ifndef `VAR'
            #define VAR "1"
            $var = `ARG';
	    #else
            $cut = `ARG';
	 #endif
      #enddo
   #endif

   $origcut=$cut;
   $cut=$origcut-count_($var,1);
   id `POW'([:x]?,[:y]?)=[:EXP]([:y]*[:LOG]([:x]));
   
   argument [:EXP];
      #call logfunction([:LOG]);
      multiply replace_([:LOG],log);
   endargument;
	
*       restore original cut
   $cut=$origcut;
   #call expfunction([:EXP]);
*simplify a bit
* 	splitarg [:EXP];
* 	chainout [:EXP];
* 	factarg [:EXP];
* 	id [:EXP](?a,log([:x]?),?b)=[:EXP](log([:x]),?a,?b);
* 	repeat id [:EXP](log([:x]?),[:y]?,[:z]?,?a)=[:EXP](log([:x]),[:y]*[:z],?a);
* 	repeat id [:EXP](log([:x]?),[:y]?)*[:EXP](log([:x]?),[:z]?)=[:EXP](log([:x]),[:y]+[:z]);
* 	id [:EXP](log([:x]?),[:y]?)=`POW'(log([:x]),[:y]);

   multiply replace_([:EXP],exp);

#endprocedure

