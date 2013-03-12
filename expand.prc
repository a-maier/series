#procedure expand(FUN,?a)
*wrapper which calls the corresponding expansion procedure

#if "`FUN'"=="exp"
#call expfunction(exp,`?a')
#elseif "`FUN'"=="log"
#call logfunction(log,`?a')
#elseif "`FUN'"=="ln"
#call logfunction(ln,`?a')
#elseif "`FUN'"=="pow"
#call powerfunction(pow,`?a')
#elseif "`FUN'"=="power"
#call powerfunction(power,`?a')
#elseif "`FUN'"=="den"
#call invertfunction(den,`?a')
#elseif "`FUN'"=="deno"
#call invertfunction(deno,`?a')
#else
#call wrapfunction(`FUN',`?a')
#endif


#endprocedure
