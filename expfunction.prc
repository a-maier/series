#procedure expfunction(EXP)
*replaces the argument arg of `EXP' by exp(arg)
*(the argument is considered as a series in $var up to power $cut)

*rewrite into product
splitarg `EXP';
chainout `EXP';

*expand each factor

while(count(`EXP',1)>0);
   once `EXP'(?a$a)=[:exp](?a);
   argument [:exp];
      $c = count_($var,1);
   endargument;
   if($c>0);
      $lim = $cut - count_($var,1);
      once [:exp]([:x]?$x) = 
      sum_([:i],0,integer_($lim/$c),([:x])^([:i])*invfac_([:i]));
   endif;
endwhile;

*return unexpanded exponentials to original form
multiply replace_([:exp],`EXP');

#endprocedure
