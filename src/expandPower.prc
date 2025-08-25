*replaces `POW'(x,y) by x^y, treating both x and y as series (as specified by the procedure series)
#procedure expandPower(POW,?SERIESSPEC)

*uses `POW'(x,y)=exp(y*log(x))

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

   $origcut = $cut;
   $cut = $origcut - count_($var,1);
   id `POW'([:x]?,[:y]?)=[:EXP]([:y]*[:LOG]([:x]));

   argument [:EXP];
      #call expandLog([:LOG]);
      multiply replace_([:LOG],log);
   endargument;

*  restore original cut
   $cut=$origcut;
   #call expandExp([:EXP]);

   multiply replace_([:EXP],exp);

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
