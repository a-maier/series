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
      #do n=0,`$maxtermnum'
	 $a`n'=0;
      #enddo

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

*     determine coefficients
*     this still needs a clever idea
*     atm it's O($maxtermnum*termsin_($x)) but should be O(termsin_($x))
      inside $x;
	 $c=count_($var,1);
	 if($c==0);
	    $a0=$a0+term_();
	    #do n=1,`$maxtermnum'
	       elseif($c==`n');
	       $a`n'=$a`n'+term_();
	    #enddo
	 endif;
      endinside;

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
      multiply (
         + [:log](($minterm) * ($var)^($minpow))
         + ($sum)
      );
   endwhile;

*  restore original notion of logs
   multiply replace_([:log],`LOG');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
