* set $var and $cut to local values
#procedure localSeries(VAR,CUT)

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

* restore global values of $var and $cut
#procedure restoreSeries()

   $var = $varstore;
   $cut = $cutstore;

#endprocedure
