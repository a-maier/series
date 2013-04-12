#procedure expandExp(EXP,?SERIESSPEC)
*replaces the argument arg of `EXP' by exp(arg)
*(the argument is considered as a series in $var up to power $cut)

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

*  increment label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   repeat id `EXP'([:x]?)*`EXP'([:y]?) = `EXP'([:x]+[:y]);
   if(match(`EXP'([:x]?$x)));

*     extract negative powers (not expandable)
      $minterm = 0;
      inside $x;
	 $c = count_($var,1);
	 if($c<0);
	    $minterm = $minterm+term_();
	 endif;
      endinside;
      $t = termsin_($minterm);
      if($t>0);
	 print "WARNING: `EXP'(%$)" $x;
	 print "   contains negative powers of %$ ,%"  $var;
	 print "which cannot be expanded";
      endif;

      #call getCoefficients(x,$var,`$maxtermnum',a)

*     determine coefficients of expanded function
      $lim = $cut - count_($var,1);

      $b0 = 1;
      #do n=1,`$maxtermnum'
	 if(`n'>$lim) goto afterloop`$labelnum';
	 $b`n' =
	 #do i=1,`n'
	    + `i'/`n'*$a`i'*$b{`n'-`i'}
	 #enddo
	 ;
      #enddo
      label afterloop`$labelnum';

*     multiply by expanded function
      $sum=sum_([:i],0,$lim,[:b]([:i]));
      once `EXP'($x) = $sum;

      $t=termsin_($a0);
      if($t>0) multiply `EXP'($a0);

   endif;

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
