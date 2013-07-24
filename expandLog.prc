#procedure expandLog(LOG,?SERIESSPEC)
*replaces the argument of `LOG' by its inverse
*(the argument is considered as a series in $var up to power $cut)

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

*  increase label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   while(match(`LOG'([:x]?)));
      $minpow=maxpowerof_([:x]);
      $minterm=0;

      once `LOG'([:x]?$x)=1;

*     determine leading term
      inside $x;
	 $c = count_($var,1);
	 if($c<$minpow);
	    $minpow=count_($var,1);
	    $minterm=term_();
	    elseif($c==$minpow);
	    $minterm=$minterm+term_();
	 endif;
      endinside;

      $minterm = $minterm*$var^-$minpow;

*     normalise log argument
      $x =  1 + (($x)*($var)^(-($minpow)) - $minterm)/($minterm);

      #call getCoefficients(x,$var,`$maxtermnum',a)

*     multiply by expanded logarithm
      $lim = $cut - count_($var,1);

      #do n=1,`$maxtermnum'
	 if(`n'>$lim) goto afterloop`$labelnum';
	 $b`n' = $a`n'
	 #do i=1,{`n'-1}
	    - `i'/`n'*$a{`n'-`i'}*$b`i'
	 #enddo
	 ;
      #enddo
      label afterloop`$labelnum';

      $sum=sum_([:i],1,$lim,[:b]([:i]));
      $sum = $sum + [:log](($minterm) * ($var)^($minpow));
      multiply $sum;
   endwhile;

*  restore original notion of logs
   multiply replace_([:log],`LOG');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
