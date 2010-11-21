#procedure invert(SOURCE,TARGET)
*inverts `SOURCE' (interpreting it as a series in `$var', up to `$var'^`$cut')
* the result is saved in `TARGET'
*	#+
	#call toseries(`SOURCE',ta)
	#define CUT "{`$cut'+{`$minpowerta'}}"
*coefficients of inverted series
	#call createtable(tb,`CUT')
	fill [:tb](0)=1/[:ta](0);
	skip;
*now higher order terms
	#do power=1,`CUT'
		L [:tmp]= -[:tb](0)*(
		#do j=1,`power'
			+([:ta](`j'))*([:tb]({`power'-`j'}))
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
	L `TARGET'= (`$var')^-(`$minpowerta')*(
	#do i=0,`CUT'
		+[:tb](`i')*`$var'^(`i')
	#enddo
	);
	.sort
	cleartable [:ta];
	cleartable [:tb];

#endprocedure

