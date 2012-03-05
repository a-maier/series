#procedure wrapfunction(FUN,?SERIESSPEC)
*expands function FUN
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

   while(match(`FUN'([:x]?)));

      #do n=0,`$maxtermnum'
	 $a`n'=0;
      #enddo

      once `FUN'([:x]?$x)=1;

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
	    elseif($c<0);
	    print "negative power of %$ in argument of `FUN':" $var;
	    print "   in term %t";
	    print "   in `FUN'(%$)" $x;
	    exit;
	 endif;
      endinside;

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

#endprocedure
