#procedure wrapfunction(FUN)
*expands function FUN
*(the argument is considered as a series in $var up to power $cut)

   while(match(`FUN'([:x]?)));

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
      multiply sum_([:i],0,$lim,[:b_f]([:i]));
      chainin [:d];
      id [:d](?a)*[:f](?b) = D(`FUN'(?b),nargs_(?a));
   
   endwhile;

   multiply replace_([:f],`FUN');

#endprocedure
