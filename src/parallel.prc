*contains the instructions that are necessary for
* parallel execution of a module when the *function
* procedures are used
#procedure parallel

   moduleoption local $var,$cut,$varstore,$cutstore;
   moduleoption local <$a0>,...,<$a`$maxtermnum'>;
   moduleoption local <$b0>,...,<$b`$maxtermnum'>;
   moduleoption local $minterm,$invminterm,$minpow,$c,$lim,$x,$t,$sum,$origcut;

#endprocedure
