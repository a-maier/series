*computes the logarithm of SOURCE,
* treating SOURCE as a series as specified by the procedure series
* the result is saved in TARGET
#procedure log(SOURCE,TARGET)

   #call toseries(`SOURCE',ta)
   #define CUT "`$cut'"
   #call createtable(tb,`CUT')
   CF log;
   skip;
*  coefficients of inverted series
   #do power=1,`CUT'
      L [:tmp]=([:ta](`power'))/([:ta](0))
      #do j=1,{`power'-1}
	 -(`j')/(`power')*([:ta]({`power'-`j'}))/([:ta](0))*([:tb](`j'))
      #enddo
      ;
      if(count([:ta],1)>0)discard;
      .sort
      #$tmp=[:tmp];
      fill [:tb](`power') = `$tmp';
      skip;
   #enddo
   .sort
   drop [:tmp];
   skip;
   L `TARGET'= log([:ta](0)*(`$var')^(`$minpowerta'))
   #do i=1,`CUT'
      +[:tb](`i')*`$var'^(`i')
   #enddo
   ;
*  throw away trivial logs -- this is a bit a waste of resources,
*  we already know that at most one term will be affected
   id once log(1)=0;

   .sort
   cleartable [:ta];
   cleartable [:tb];

#endprocedure
