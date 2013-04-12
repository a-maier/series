#procedure expandGamma(GAMMA,?SERIESSPEC)
* expand Gamma functions in $var up to power $cut

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

   #define l

*  increase label number to make sure it's unique
   #$labelnum=`$labelnum'+1;

   while(match(`GAMMA'([:x]?$x)));
      #do n=0,`$maxtermnum'
	 $a`n'=0;
      #enddo

*     determine coefficients
      inside $x;
	 $c=count_($var,1);
	 if($c<0);
	    print "argument of Gamma function `GAMMA'(%$)" $x;
	    print "contains negative powers of %$ and cannot be expanded" $var;
	    exit;
	    #do n=0,`$maxtermnum'
	       elseif($c==`n');
	       $a`n'=$a`n'+term_();
	    #enddo
	 endif;
      endinside;

*     determine coefficients of expanded function
      $lim = $cut - count_($var,1);

      $b0 = 1;
      #do n=1,`$maxtermnum'
	 if(`n'>$lim) goto afterloop`$labelnum';
	 #$PARTSIZE = 0;
*        sum over partitions of `n'
	 #do i = 0,0,0
	    #call nextPartition(`n',PART)
	    #call computeMultiplicities(PART,MULTIPLICITY)
	    #if `$PARTSIZE' == 0
*	       after last partition
	       #breakdo

	       #elseif `$PARTSIZE' == 1
*              trivial partition
	       $b`n' = psi(0,$a0)*$a`n';

	       #else
	       $b`n' =
	       + $b`n'
	       + psi({`$PARTSIZE'-1},$a0)
	       #do j=1,`$PARTSIZE',1
		  #redefine l "`$PART`j''"
		  * $a`l'^`$MULTIPLICITY`l''/{`$MULTIPLICITY`l''!}
		  #redefine j "{`j'+`$MULTIPLICITY`l''-1}"
	       #enddo
	       + {{`$PARTSIZE'-1}!}
	       #do j=1,`$PARTSIZE',1
		  #redefine l "`$PART`j''"
		  * (-$b`l')^`$MULTIPLICITY`l''/{`$MULTIPLICITY`l''!}
		  #redefine j "{`j'+`$MULTIPLICITY`l''-1}"
	       #enddo
	       ;
	    #endif
	 #enddo
      #enddo
      label afterloop`$labelnum';

*     multiply by expanded function
      $sum= sum_([:i],0,$lim,[:b]([:i]));
      once `GAMMA'($x) = [:Gamma]($a0) * $sum;

   endwhile;

   multiply replace_([:Gamma],`GAMMA');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
