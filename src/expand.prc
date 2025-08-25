*wrapper which calls the corresponding expansion procedure
#procedure expand(FUN,?a)

   #if "`FUN'"=="`$exponential'"
      #call expandExp(`FUN',`?a')
   #elseif "`FUN'"=="`$logarithm'"
      #call expandLog(`FUN',`?a')
   #elseif "`FUN'"=="`$power'"
      #call expandPower(`FUN',`?a')
   #elseif "`FUN'"=="`$denominator'"
      #call expandDenominator(`FUN',`?a')
   #elseif "`FUN'"=="`$gamma'"
      #call expandGamma(`FUN',`?a')
   #else
      #call expandFunction(`FUN',`?a')
   #endif

#endprocedure
