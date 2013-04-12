#procedure localSeries(VAR,CUT)
* set $var and $cut to local values

   #ifdef `$var'
      $varstore = $var;
      $cutstore = $cut;
      #else
      $varstore = `VAR';
      $cutstore = `CUT';
   #endif
   $var = `VAR';
   $cut = `CUT';

#endprocedure

#procedure restoreSeries()
* restore global values of $var and $cut

   $var = $varstore;
   $cut = $cutstore;

#endprocedure
