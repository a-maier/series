#procedure expfunction(EXP,?SERIESSPEC)
*replaces the argument arg of `EXP' by exp(arg)
*(the argument is considered as a series in $var up to power $cut)

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

*rewrite into product
splitarg `EXP';
chainout `EXP';

*expand each factor

while(count(`EXP',1)>0);
   once `EXP'(?a)=[:exp](?a);
   argument [:exp];
      $c = count_($var,1);
   endargument;
   if($c>0);
      $lim = $cut - count_($var,1);
      once [:exp]([:x]?) = 
      sum_([:i],0,integer_($lim/$c),([:x])^([:i])*invfac_([:i]));
      else;
      once [:exp](?a)=[:f](?a);
   endif;
endwhile;

*return unexpanded exponentials to original form
multiply replace_([:f],`EXP');

#endprocedure
