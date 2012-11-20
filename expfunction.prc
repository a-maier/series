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

*  increase label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   repeat id `EXP'([:x]?)*`EXP'([:y]?) = `EXP'([:x]+[:y]);
   #do n=0,`$maxtermnum'
      $a`n'=0;
   #enddo
   $minterm = 0;

   once `EXP'([:x]?$x)=1;

*  determine coefficients
*  this still needs a clever idea
*  atm it's O($maxtermnum*termsin_($x)) but should be O(termsin_($x))
   inside $x;
      $c=count_($var,1);
      if($c<1);
*           also negative powers go here, because we cannot expand them
*           would be nice to have a warning, but could easily lead to spam
         $a0 = $a0 + term_();
	 #do n=1,`$maxtermnum'
	    elseif($c==`n');
	    $a`n'=$a`n'+term_();
	 #enddo
      endif;
   endinside;
   
*  determine coefficients of expanded function
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

*  multiply by expanded function 
   $sum=sum_([:i],0,$lim,[:b]([:i]));
   multiply $sum;

   $t=termsin_($a0);
   if($t>0) multiply [:exp]($a0);
   
*  restore original notion of exponential function
   multiply replace_([:exp],`EXP');

#endprocedure
