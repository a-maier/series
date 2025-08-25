*wrapper which calls the corresponding expansion procedure
#procedure expand(FUN,?a)

   #if "`FUN'"=="exp"
      #call expandExp(`FUN',`?a')
      #elseif ( ("`FUN'"=="log") || ("`FUN'"=="ln") )
      #call expandLog(`FUN',`?a')
      #elseif ( ("`FUN'"=="pow") || ("`FUN'"=="power") )
      #call expandPower(`FUN',`?a')
      #elseif ( ("`FUN'"=="den") || ("`FUN'"=="deno") )
      #call expandDenominator(`FUN',`?a')
      #elseif "`FUN'"=="Gamma"
      #call expandGamma(`FUN',`?a')
      #else
      #call expandFunction(`FUN',`?a')
   #endif

#endprocedure
