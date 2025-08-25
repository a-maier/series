* normalises the argument of the denominator function `DENO':
* `DENO'(norm*x) -> [:inv](norm)*`DENO'(x) with x = 1 + O($var),
* where $var is the expansion variable
* [:inv](norm) is simplified to 1/norm if norm is a single term
#procedure seriesNormaliseDenominator(DENO,?SERIESSPEC)

   #ifdef `?SERIESSPEC'
      #call localSeries(`?SERIESSPEC')
   #endif

   while(match(`DENO'([:x]?)));
      $minpow=maxpowerof_([:x]);
      $minterm=0;

      once `DENO'([:x]?$x)=1;

*     determine leading term
      inside $x;
         multiply replace_(`DENO', [:inv]);
	 $c = count_($var,1);
	 if($c<$minpow);
	    $minpow=count_($var,1);
	    $minterm=term_();
	    elseif($c==$minpow);
	    $minterm=$minterm+term_();
	 endif;
      endinside;

      $minterm = ($minterm)*($var)^(-($minpow));

      $t = termsin_($minterm);
      if($t==1);
	 $invminterm = 1/$minterm;
	 else;
	 $invminterm = [:inv]($minterm);
      endif;

*     normalise denominator
      $x =  1 + ($invminterm)*(($x)*($var)^(-($minpow)) - $minterm);

      $t = termsin_($x);
      if($t==1);
	 $x = 1/$x;
	 else;
	 $x = [:den]($x);
      endif;

      multiply $invminterm*$var^-$minpow*$x;
   endwhile;

*  restore original notion of denominators
   multiply replace_([:den],`DENO');

   #ifdef `?SERIESSPEC'
      #call restoreSeries
   #endif

#endprocedure
