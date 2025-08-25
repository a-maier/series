#procedure expandDenominator(DENO,?SERIESSPEC)
*replaces the argument of `DENO' by its inverse
*(the argument is considered as a series in $var up to power $cut)

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

*  increase label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   #call seriesNormaliseDenominator(`DENO')

   while(match(`DENO'([:x]?)));
      once `DENO'([:x]?$x)=1;

      #call getCoefficients(x,$var,`$maxtermnum',a)

*     multiply by expanded inverse of normalised denominator
      $lim = $cut - count_($var,1);
      $b0=1;
      #do n=1,`$maxtermnum'
	 if(`n'>$lim) goto afterloop`$labelnum';
	 $b`n' =
	 #do i=0,{`n'-1}
	    - $a{`n'-`i'}*$b`i'
	 #enddo
	 ;
      #enddo
      label afterloop`$labelnum';

      $sum=sum_([:i],0,$lim,[:b]([:i]));
      multiply $sum;

   endwhile;

*  restore original notion of denominators
   multiply replace_([:den],`DENO',[:inv],`DENO');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
