#procedure powerfunction(POW)
*replaces `POW'(x,y) by x^y, treating both x and y as series (as specified by the procedure series)

*uses `POW'(x,y)=exp(y*log(x))

	$cut=`$cut'-count_(`$var',1);
	id `POW'([:x]?,[:y]?)=[:exp]([:y]*[:log]([:x]));
	
	argument [:exp];
	#call logfunction([:log]);
	id [:log](?a)=log(?a);
	endargument;
	
	$cut=`$cut';
	#call expfunction([:exp]);
*simplify a bit
* 	splitarg [:exp];
* 	chainout [:exp];
* 	factarg [:exp];
* 	id [:exp](?a,log([:x]?),?b)=[:exp](log([:x]),?a,?b);
* 	repeat id [:exp](log([:x]?),[:y]?,[:z]?,?a)=[:exp](log([:x]),[:y]*[:z],?a);
* 	repeat id [:exp](log([:x]?),[:y]?)*[:exp](log([:x]?),[:z]?)=[:exp](log([:x]),[:y]+[:z]);
* 	id [:exp](log([:x]?),[:y]?)=`POW'(log([:x]),[:y]);


 	id [:exp](?a)=exp(?a);


#endprocedure


* nskip [:tmp_pow];
* b ep;
* print;

