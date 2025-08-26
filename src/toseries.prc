*transforms `source' into a series (read the coefficients into the table `tab')
#procedure toseries(source,tab)

   #if exists($var) == 0
      #message no series found
      #message (please call series(var,cut) first)
      #terminate
   #endif

   .sort
   skip;
   nskip `source';
*  find lowest & highest power of $variable
   #$minpower`tab'=maxpowerof_(`$var');
*  #$maxpower`tab'=minpowerof_(`$var');
   #$maxpower`tab'=-maxpowerof_(`$var');
   if(count(`$var',1)<$minpower`tab') $minpower`tab'=count_(`$var',1);
   if(count(`$var',1)>$maxpower`tab') $maxpower`tab'=count_(`$var',1);
   moduleoption minimum $minpower`tab';
   moduleoption maximum $maxpower`tab';
   .sort
   #define SIZE "{`$maxpower`tab''-{`$minpower`tab''}}"
   S [:x];
   skip;
   nskip `source';
*  make the expansion start from `$var'^0
*  replace the expansion variable by some auxiliary variable
*  in order to circumvent global cuts
*  (i.e. from 'Symbol `$var'(:`cut'))
   multiply [:x]^-(`$minpower`tab'');
*replace_(`$var',[:x]);
   id `$var'=[:x];
   id `$var'^-1=[:x]^-1;
   b+ [:x];
   .sort
*  fill coefficients into table
   #call createtable(`tab',`SIZE')

   fillexpression [:`tab']=`source'([:x]);
   skip;
   nskip `source';
   multiply [:x]^(`$minpower`tab'');
   multiply replace_([:x],`$var');
   .sort

#endprocedure
