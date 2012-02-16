#procedure logfunction(LOG)
*replaces the argument of `LOG' by its inverse
*(the argument is considered as a series in $var up to power $cut)

   while(match(`LOG'([:x]?)));
      $minpow=maxpowerof_(`$var');
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

      $t = termsin_($minterm);
      if($t==1);
	 $invminterm = 1/$minterm;
	 else;
	 $invminterm = [:den]($minterm);
      endif;

*     normalise log argument
      $x =  1 + ($invminterm)*(($x)*($var)^(-($minpow)) - $minterm);

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
      multiply (
         + [:log](($minterm) * ($var)^($minpow))
         + sum_([:i],1,$lim,[:b_log]([:i]))
      );
   endwhile;
   
*  restore original notion of logs
   multiply replace_([:log],`LOG');


#endprocedure
