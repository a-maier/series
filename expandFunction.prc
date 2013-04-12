#procedure expandFunction(FUN,?SERIESSPEC)
*expands function FUN
*(the argument is considered as a series in $var up to power $cut)

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

*  increase label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   while(match(`FUN'([:x]?)));

      once `FUN'([:x]?$x)=1;

      #call getCoefficients(x,$var,`$maxtermnum',a)

*     multiply by expanded function

      $lim = $cut - count_($var,1);
      $b0=D([:f]($a0),0);
      #do n=1,`$maxtermnum'
	 if(`n'>$lim) goto afterloop`$labelnum';
	 $b`n' =
	 #do i=1,`n'
	    + `i'/`n'*$a`i'*$b{`n'-`i'}
	 #enddo
	 ;
	 inside $b`n';
	    id D([:x]?,[:y]?)=D([:x],[:y]+1);
	 endinside;
      #enddo
      label afterloop`$labelnum';
      $b0=[:f]($a0);

      $sum=sum_([:i],0,$lim,[:b]([:i]));
      multiply $sum;

   endwhile;

   multiply replace_([:f],`FUN');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
