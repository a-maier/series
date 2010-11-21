#procedure expand(FUN)
*wrapper which calls the corresponding expansion procedure

#if `FUN'=="exp"
#call expfunction(exp)
#elseif `FUN'=="log"
#call logfunction(log)
#elseif `FUN'=="ln"
#call logfunction(ln)
#elseif `FUN'=="pow"
#call powerfunction(pow)
#elseif `FUN'=="power"
#call powerfunction(power)
#elseif `FUN'=="den"
#call invertfunction(den)
#elseif `FUN'=="deno"
#call invertfunction(deno)

#else
#message Don't know how to expand function `FUN'
#terminate
#endif


#endprocedure
