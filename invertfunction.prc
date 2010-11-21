#procedure invertfunction(DENO)
*replaces the argument of `DENO' by its inverse
*(the argument is considered as a series in $var up to power $cut)

chainin `DENO';

*normalise
$minpower=maxpowerof_(`$var');
argument `DENO';
term;
if(count(`$var',1)<$minpower) $minpower=count_(`$var',1);
endterm;
endargument;
id once `DENO'([:x]?)=
`$var'^-($minpower)*`DENO'((`$var')^(-($minpower))*[:x])
;
if(count(`$var',1)>$cut)discard;
*rewrite into list of coefficients
* i.e a product of [:f](coefficient, power of expansion variable)
splitarg ((`$var')) `DENO';
chainout `DENO';
factarg `DENO';
id `DENO'(?a)=[:f](?a,0);
repeat id [:f](?a,`$var',?b,[:x]?)=[:f](?a,?b,[:x]+1);
id [:f]([:x]?)=[:f](1,[:x]);
repeat id [:f](?a,[:x]?,[:y]?,[:z]?)=[:f](?a,[:x]*[:y],[:z]);
repeat id [:f]([:x]?,[:z]?)*[:f]([:y]?,[:z]?)=[:f]([:x]+[:y],[:z]);

*compute coefficients of inverse series
$i=count_(`$var',1);
multiply 1+sum_([:z],1,($cut)-($i),[series::partition]([:z])*`$var'^[:z]);

repeat id once [series::c]([:x]?,[:y]?)*[:f]([:z]?,0)=[series::c]([:x])^[:y]*[:z]^(-[:y])*[:f]([:z],0);
 $partitioncardinality=count_([series::c],1);
*print "%t has cardinality %$" $partitioncardinality;
multiply (-1)^($partitioncardinality)*fac_($partitioncardinality);

* insert coefficients
* *optimise this line
repeat id once [series::c]([:x]?)*[:f]([:z]?,[:x]?)=[:z]*[:f]([:z],[:x]);

if(count([series::c],1)>0)discard;
id [:f]([:x]?,0)=1/[:x];
id [:f](?a)=1;


#endprocedure
