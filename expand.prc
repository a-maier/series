#procedure expand(FUN,?a)
*wrapper which calls the corresponding expansion procedure

   #if "`FUN'"=="exp"
      #call expandExp(`FUN',`?a')
      #elseif ( ("`FUN'"=="log") || ("`FUN'"=="ln") )
      #call expandLog(`FUN',`?a')
      #elseif ( ("`FUN'"=="pow") || ("`FUN'"=="power") )
      #call expandPower(`FUN',`?a')
      #elseif ( ("`FUN'"=="den") || ("`FUN'"=="deno") )
      #call expandDenominator(`FUN',`?a')
      #else
      #call expandFunction(`FUN',`?a')
   #endif

#endprocedure
