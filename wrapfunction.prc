#procedure wrapfunction(FUN)
*expands function FUN
*(the argument is considered as a series in $var up to power $cut)

*normalise
$minpower=maxpowerof_(`$var');
argument `FUN';

term;
if(count(`$var',1)<$minpower) $minpower=count_(`$var',1);
endterm;

if($minpower<0);
$term=term_();
print "Argument of `FUN' contains negative powers of  `$var' in term %$" $term;
exit;
endif;

endargument;

*rewrite into list of coefficients
* i.e a product of [:f](coefficient, power of expansion variable)
splitarg ((`$var')) `FUN';
chainout `FUN';
factarg `FUN';

id `FUN'(?a)=[:f](?a,0);
repeat id [:f](?a,`$var',?b,[:x]?)=[:f](?a,?b,[:x]+1);
id [:f]([:x]?)=[:f](1,[:x]);
repeat id [:f](?a,[:x]?,[:y]?,[:z]?)=[:f](?a,[:x]*[:y],[:z]);
repeat id [:f]([:x]?,[:z]?)*[:f]([:y]?,[:z]?)=[:f]([:x]+[:y],[:z]);

*id once [:f](?a,0)= `FUN'(?a)+[:f](?a,0);
*compute coefficients of series

$i=count_($var,1);
multiply sum_([:z],0,($cut)-($i),[series::partition]([:z])*`$var'^[:z]);
id [series::partition](0)*[series::f]([:x]?,0)=`FUN'([:x]);
repeat id once [series::c]([:x]?,[:y]?)*[:f]([:z]?,0)=[series::c]([:x])^[:y]*[:f]([:z],0)*D(`FUN'([:z]),[:y]);
* insert coefficients
* *optimise this line
repeat id once [series::c]([:x]?)*[:f]([:z]?,[:x]?)=[:z]*[:f]([:z],[:x]);

if(count([series::c],1)>0)discard;

id [:f](?a)=1;
repeat id D([:x]?,[:y]?)*D([:x]?,[:z]?)=D([:x],[:y]+[:z]);

#endprocedure
