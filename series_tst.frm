* test the functionality of the series package
#-
#define CUT "5"
#define TESTS "6"
#define FAIL "0"

off stats;
off warnings;
#include- series.h
S ep,c,d0,...,d`CUT';
CF pow;
L foo=c*ep^-2+<d0*ep^0>+...+<d`CUT'*ep^`CUT'>;

#message Test1: Inversion
#call series(ep,{`CUT'+2})
#call invert(foo,bar)
L [0]=foo*bar-1;
if(count(ep,1)>`CUT')discard;
.sort
drop [0];
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif

#message Test2: Exponentiation & Logarithm
#call series(ep,`CUT')
#call exp(foo,bar)
#call log(bar,bar)
L [0]=bar-foo
;
id 1/exp(c?)=exp(-c);
repeat id exp(d0?)*exp(d1?)=exp(d0+d1);
id exp(0)=1;
id log(exp(c?))=c;
.sort
drop [0];
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif

#message Test3: Power
L [-2]=-2;
L [-1/2]=-1/2;
#call series(ep,{`CUT'+2})
#call power(foo,[-2],bar)
#call power(bar,[-1/2],bar2)
drop bar;
skip;
nskip bar2;
id 1/exp(c?)=exp(-c);
repeat id exp(d0?)*exp(d1?)=exp(d0+d1);
id exp(0)=1;
argument exp;
id log(exp(c?))=c;
endargument;
id exp(log(c?))=c;
if(count(ep,1)>`CUT')discard;
.sort
L [0]=foo-bar2;
.sort
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif

#call init(`CUT')

#message Test4: inverse function
.sort
cf den;
skip foo;
L [0]=foo*den(foo)-1;
#call expand(den)
.sort
drop [0];
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif

#message Test5: exponential & logarithm function
.sort
cf exp,log;
skip foo;
L [0]=exp(log(foo))-foo;
argument exp;
#call expand(log)
endargument;
#call expand(exp)
splitarg exp;
chainout exp;
id exp(log(c?))=c;
.sort
drop [0];
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif

#message Test6: power function
.sort
cf power;
skip foo;
L [0]=power(power(foo,-2),-1/2)-foo;
argument power;
#call expand(power)
endargument;
#call expand(power)
id 1/exp(c?)=exp(-c);
id 1/(exp(c?)^2)=exp(-c)^2;
id 1/(exp(c?)^3)=exp(-c)^3;
repeat id exp(c?)*exp(d0?)=exp(c+d0);
argument exp;
id log(exp(c?))=c;
endargument;
splitarg exp;
chainout exp;
id exp(log(c?))=c;
.sort
drop [0];
#if termsin([0])>0
#message FAILED
#redefine FAIL "{`FAIL'+1}"
#else 
#message passed
#endif


#if `FAIL'==0
#message All tests passed
#else 
#message Failed `FAIL'/`TESTS' tests
#terminate 1
#endif
.end
