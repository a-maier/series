#procedure expand(FUN,?a)
*wrapper which calls the corresponding expansion procedure

   #if "`FUN'"=="exp"
      #call expandExp(exp,`?a')
      #elseif "`FUN'"=="log"
      #call expandLog(log,`?a')
      #elseif "`FUN'"=="ln"
      #call expandLog(ln,`?a')
      #elseif "`FUN'"=="pow"
      #call expandPower(pow,`?a')
      #elseif "`FUN'"=="power"
      #call expandPower(power,`?a')
      #elseif "`FUN'"=="den"
      #call expandDenominator(den,`?a')
      #elseif "`FUN'"=="deno"
      #call expandDenominator(deno,`?a')
      #else
      #call expandFunction(`FUN',`?a')
   #endif

#endprocedure
