#procedure id(LHS,RHS)
*replace LHS by the expression RHS in all active expressions (aside from RHS)

	#ifndef `$var'
		#message no series found
		#message (please call series(var,cut) first)
		#terminate
	#endif
*abbreviations for convenience
	#define VAR "`$var'"
	#define CUT "`$cut'"
	.sort
	skip;
	nskip `RHS';
*find out minimal power
	#$minpower=maxpowerof_(`VAR');
	if(count(`VAR',1)<$minpower) $minpower=count_(`VAR',1);
	b+ `VAR';
	moduleoption minimum $minpower;
	.sort
	S [i];
	skip `RHS';
	repeat;
*insert the RHS to the correct order so that no terms are thrown away
		$termpower=count_(`VAR',1);
		id once `LHS'=sum_([i],`$minpower',`CUT'-$termpower,`RHS'[`VAR'^[i]]*`VAR'^[i]);
	endrepeat;
	moduleoption local $termpower;
	.sort

#endprocedure
