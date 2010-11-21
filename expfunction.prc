#procedure expfunction(EXP)
*replaces the argument arg of `EXP' by exp(arg)
*(the argument is considered as a series in $var up to power $cut)

*rewrite into product
splitarg `EXP';
chainout `EXP';

*rewrite into list of coefficients
* i.e a product of [:f](coefficient, power of expansion variable)
factarg `EXP';
id `EXP'(?a)=[:f](?a,0);
repeat id [:f](?a,`$var',?b,[:x]?)=[:f](?a,?b,[:x]+1);
id [:f]([:x]?)=[:f](1,[:x]);
repeat id [:f](?a,[:x]?,[:y]?,[:z]?)=[:f](?a,[:x]*[:y],[:z]);
repeat id [:f]([:x]?,[:z]?)*[:f]([:y]?,[:z]?)=[:f]([:x]+[:y],[:z]);
id [:f]([:x]?,0) = `EXP'([:x]);

*compute coefficients of inverse series
while(match([:f]([:x]?,[:y]?)));
	$i=($cut)-count_(ep,1);
	id once [:f]([:x]?,[:y]?)=sum_([:z],0,integer_(($i)/[:y]),([:x]*(`$var')^[:y])^[:z]*invfac_([:z]));
endwhile;


#endprocedure
