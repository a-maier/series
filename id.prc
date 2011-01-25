#procedure id(LHS,RHS)
*replace LHS by the expression RHS in all active expressions (aside from RHS)

	#call toseries(`RHS',ta)
	skip;
*count power of $var on the left hand side
	L [:tmp]=`LHS';
	$powerlhs=count_(`$var',1);
	.sort
	S [:x];
	skip `RHS';drop [:tmp];
	$ulim=`$cut'+(`$powerlhs')-count_(`$var',1);
	id once `LHS'=sum_([:x],`$minpowerta',$ulim,[:ta]([:x]-`$minpowerta')*(`$var')^[:x]);
	if(count([:ta],1)>0)discard;
	moduleoption,local,$ulim;
	.sort

#endprocedure
