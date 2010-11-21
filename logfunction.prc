#procedure logfunction(LOG)
*replaces the argument of `LOG' by its inverse
*(the argument is considered as a series in $var up to power $cut)
*TODO log(a)*log(b)=?

*normalise
$minpower=maxpowerof_(`$var');
argument `LOG';
term;
if(count(`$var',1)<$minpower) $minpower=count_(`$var',1);
endterm;
endargument;
id once `LOG'([:x]?)=
*[:g] is only a placeholder for `LOG'
[:g](`$var'^($minpower))+`LOG'((`$var')^(-($minpower))*[:x])
;
*rewrite into list of coefficients
* i.e a product of [:f](coefficient, power of expansion variable)
splitarg ((`$var')) `LOG';
chainout `LOG';
factarg `LOG';

id `LOG'(?a)=[:f](?a,0);
repeat id [:f](?a,`$var',?b,[:x]?)=[:f](?a,?b,[:x]+1);
id [:f]([:x]?)=[:f](1,[:x]);
repeat id [:f](?a,[:x]?,[:y]?,[:z]?)=[:f](?a,[:x]*[:y],[:z]);
repeat id [:f]([:x]?,[:z]?)*[:f]([:y]?,[:z]?)=[:f]([:x]+[:y],[:z]);

id once [:f](?a,0)= `LOG'(?a)+[:f](?a,0);
id once [:g](?a)= `LOG'(?a);
*compute coefficients of inverse series
if(match([:f](?a,0)));

$i=count_(ep,1);
multiply sum_([:z],1,($cut)-($i),[series::partition]([:z])*`$var'^[:z]);
repeat id once [series::c]([:x]?,[:y]?)*[:f]([:z]?,0)=[series::c]([:x])^[:y]*[:z]^(-[:y])*[:f]([:z],0);
 $partitioncardinality=count_([series::c],1)-1;
*print "%t has cardinality %$" $partitioncardinality;
if($partitioncardinality>0);
multiply (-1)^($partitioncardinality)*fac_($partitioncardinality);
endif;
* insert coefficients
* *optimise this line
repeat id once [series::c]([:x]?)*[:f]([:z]?,[:x]?)=[:z]*[:f]([:z],[:x]);

if(count([series::c],1)>0)discard;

else;
id once `LOG'(1)=0;
endif;
id [:f](?a)=1;


#endprocedure
