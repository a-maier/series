#procedure getCoefficients(X,VAR,CUT,C)
*   extract the coefficients of `VAR' to some power in $`X'
*   the powers can range from 0 to `CUT'
*   the resulting coefficients are saved to $`C'0,...,$`C'`CUT'

   #do i=0,`CUT'
      $`C'`i' = 0;
   #enddo

*  this is O(`CUT'*termsin_($`X')), but should be O(termsin_($`X'))
*  O(log(`CUT')*termsin_($`X')) could be achieved with a binary search,
*  but this does not appear to be a performance bottleneck
   inside $`X';
      $c=count_(`VAR',1);
      if($c==0);
         $`C'0 = $`C'0 + term_();
	 #do n=1,`CUT'
	    elseif($c==`n');
	    $`C'`n'=$`C'`n'+term_();
	 #enddo
	 else;
	 print "power %$ out of range [0,`CUT']" $c;
	 print "   in term %t";
	 setexitflag;
      endif;
   endinside;
   
#endprocedure
