#procedure Gamma(SOURCE,TARGET)
*computes the Gamma function with argument SOURCE,
* treating SOURCE as a series as specified by the procedure series
* the result is saved in TARGET

   #call toseries(`SOURCE',ta)
   #define CUT "`$cut'"
   #call createtable(tb,`CUT')
   fill [:tb](0) = 1;
   CF Gamma;
   hide `SOURCE';
*  coefficients of inverted series
   #do power=1,`CUT'
      #$PARTSIZE = 0;
*     sum over partitions of `power''
      #do i = 0,0,0
	 #call nextPartition(`power',PART)
	 #call computeMultiplicities(PART,MULTIPLICITY)
	 #if `$PARTSIZE' == 0
*	    after last partition
	    #breakdo
	    #elseif `$PARTSIZE' == 1
*           trivial partition
	    skip;
	    l [:tmp] = + psi(0,[:ta](0))*[:ta](`power');
	    .sort
	    
	    #else
	    skip;
	    l [:tmp] = [:tmp] + psi({`$PARTSIZE'-1},[:ta](0))
	    #do j=1,`$PARTSIZE',1
	       #redefine l "`$PART`j''"
	       * [:ta](`l')^`$MULTIPLICITY`l''/{`$MULTIPLICITY`l''!}
	       #redefine j "{`j'+`$MULTIPLICITY`l''-1}"
	    #enddo
	    + {{`$PARTSIZE'-1}!}
	    #do j=1,`$PARTSIZE',1
	       #redefine l "`$PART`j''"
	       * (-[:tb](`l'))^`$MULTIPLICITY`l''/{`$MULTIPLICITY`l''!}
	       #redefine j "{`j'+`$MULTIPLICITY`l''-1}"
	    #enddo
	    ;
	    if(count([:ta],1)>0)discard;
	    .sort
	 #endif
      #enddo
      #$tmp=[:tmp];
      fill [:tb](`power') = `$tmp';
      skip;
   #enddo
   .sort
   drop [:tmp];
   skip;
   L `TARGET'= Gamma([:ta](0))*(1
   #do i=1,`CUT'
      +[:tb](`i')*`$var'^(`i')
   #enddo
   );
   .sort
   cleartable [:ta];
   cleartable [:tb];
   unhide `SOURCE';

#endprocedure
