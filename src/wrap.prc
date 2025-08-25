*computes FUN(SOURCE), treating SOURCE as a series
* as specified by the procedure series
* the result is saved in TARGET
#procedure wrap(SOURCE,FUN,TARGET)

   #call toseries(`SOURCE',ta)
   #if `$minpowerta'<0
      #message Argument `SOURCE' of `FUN' contains negative powers of  `$var'
      #terminate
      #elseif `$minpowerta'==0
      #define FUNARG "[:ta](0)"
      #else
      #define FUNARG "0"
   #endif
   #call createtable(tb,`$cut')

*  coefficients of result series
   S [:d],[:x];
   fill [:tb](0)=`FUN'(`FUNARG');
   skip;
*  now higher order terms
   #do power=1,`$cut'
      L [:tmp]=
      #do j=1,`power'
	 + [:d]*(`j')/(`power')
	   *([:ta]({`j'-`$minpowerta'}))
	   *([:tb]({`power'-`j'}))
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
   L `TARGET'=
   #do i=0,`$cut'
      +[:tb](`i')*`$var'^(`i')
   #enddo
   ;
   id [:d]^[:x]?{>0}*`FUN'(?a) = `$derivative'(`FUN'(?a),[:x]);
   .sort
   cleartable [:tb];

#endprocedure
