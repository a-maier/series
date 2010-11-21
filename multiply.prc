#procedure multiply(SOURCE1,SOURCE2,TARGET)
*multiplys the expressions SOURCE1 and SOURCE2 and saves the result in TARGET

	#ifndef `$var'
		#message no series found
		#message (please call series(var,cut) first)
		#terminate
	#endif
*abbreviations for convenience
	#define VAR "`$var'"
	#define CUT "`$cut'"

	.sort
*find out minimal powers in both expressions
#do i=1,2
	skip;
	nskip `SOURCE`i'';
	#$`i'minpower=maxpowerof_(`VAR');
	if(count(`VAR',1)<$`i'minpower) $`i'minpower=count_(`VAR',1);
	moduleoption minimum $`i'minpower;
	.sort
#enddo

	skip;
	nskip `SOURCE1',`SOURCE2';
	b+ `VAR';
	.sort
* use Cauchy multiplication
	L `TARGET'=
	#do n={`$1minpower'+`$2minpower'},`CUT'
		#do i=`$1minpower',`n'
			+`SOURCE1'[`VAR'^`i']*`SOURCE2'[`VAR'^{`n'-`i'}]*`VAR'^`n'
		#enddo
	#enddo
	;
	.sort

#endprocedure
