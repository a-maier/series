*computes BASE^EXP, treating both as series (as specified by the procedure series)
* the result is saved in `TARGET'
* for more complicated exponents, use seriespower
* inverting a series is probably faster with seriesinvert
#procedure simplepower(BASE,EXP,TARGET)

	#if exists($var) == 0
		#message no series found
		#message (please call series(var,cut) first)
		#terminate
	#endif
*abbreviations for convenience
	#define VAR "`$var'"
	#define CUT "`$cut'"
	.sort
	skip;
	nskip `BASE';
* find out minimal power in expression
	#$minpower=maxpowerof_(`VAR');
	if(count(`VAR',1)<$minpower) $minpower=count_(`VAR',1);
	b `VAR';
	moduleoption minimum $minpower;
	.sort
	skip;
*normalise series
	#$C0=`BASE'[`VAR'^`$minpower'];
	L [tmp]=`BASE'*`VAR'^(-`$minpower')/`$C0';
	b+ `VAR';
	.sort
	CF [partition],[c],[helper];
	S [x],[y],[z];
	skip;
	drop [tmp];
*define as a sum over partitions (see the reference manual)
*the prefactors of the series coefficients will be adjusted later on
* [partition](i,j) generates all partitions of i with largest element j
* [c](i,j) means the series coefficient number i to the power j
	#redefine CUT "{`CUT'-{(`$minpower')*(`EXP')}}"
	L `TARGET'=1
	#do i=1,`CUT'
		+ [helper](-1)*[partition](`i',`i')*`VAR'^`i'
	#enddo
	;

*generate all partitions
	#call partition()
*insert rest of the coefficient
	repeat id once [helper]([z]?)*[c]([x]?,[y]?)
	=[helper]([z]+[y])*[c]([x])^[y];
	repeat id once [helper]([x]?{>0})=(`EXP'-[x])*[helper]([x]-1);
	id once [helper](0)=`EXP';
*insert series coefficients and restore overall factor
	id [c]([x]?)=[tmp][`VAR'^[x]];
	multiply `$C0'^(`EXP')*`VAR'^(`$minpower'*(`EXP'));
	.sort

#endprocedure
