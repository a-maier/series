#procedure exp(SOURCE,TARGET)
*computes e^SOURCE, treating SOURCE as a series as specified by the procedure series
* the result is saved in TARGET

	#call toseries(`SOURCE',ta)
	#define CUT "{`$cut'}"
	#call createtable(tb,`CUT')
*coefficients of result series
	fill [:tb](0)=1;
	skip;
*now higher order terms
	#do power=1,`CUT'
		L [:tmp]= (
		#do j=1,`power'
			+(`j')/(`power')*([:ta]({`j'-{`$minpowerta'}}))*([:tb]({`power'-`j'}))
		#enddo
		);
		if(count([:ta],1)>0)discard;
		.sort
		#$tmp=[:tmp];
		fill [:tb](`power') = `$tmp';
		skip;
	#enddo
*	#preout off
	.sort
	drop [:tmp];
	skip;
	L `TARGET'= 
	#do i=0,`CUT'
		+[:tb](`i')*`$var'^(`i')
	#enddo
	;
	.sort
	cleartable [:tb];



*if the series starts from a power that is smaller than one, these parts cannot be expanded and we keep them
	#if `$minpowerta'<1
		#if `$minpowerta'<0
			#message WARNING: expression in exponent is not analytic
			#message some parts will not be expanded
		#endif
		S [:x];
		CF exp;
		skip;
		nskip `TARGET';
		multiply exp( sum_([:x],0,-(`$minpowerta'),[:ta]([:x])*`$var'^([:x]+(`$minpowerta')) ) );
		argument exp;
		if(count([:ta],1)>0)discard;
		endargument;
		.sort
	#endif
	cleartable [:ta];

#endprocedure
