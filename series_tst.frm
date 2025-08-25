* test the functionality of the series package
#-
#define CUT "5"
#define TESTS "15"
#define FAIL "0"

off stats;
off warnings;
#include- series.h # 2.0.0
#call series(init,{2*{`CUT'+2}})
S ep,c,d0,...,d`CUT';
CF pow;
L foo=c*ep^-2+<d0*ep^0>+...+<d`CUT'*ep^`CUT'>;

#message Test1: Inversion
#call series(setExpansion,ep,{`CUT'+2})

#call series(invert,foo,bar)
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
#call series(setExpansion,ep,`CUT')
#call series(exp,foo,bar)
#call series(log,bar,bar)
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
#call series(setExpansion,ep,{`CUT'+2})
#call series(power,foo,[-2],bar)
#call series(power,bar,[-1/2],bar2)
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
drop bar2,[-2],[-1/2];
L [0]=foo-bar2;
.sort
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test4: inverse function
.sort
cf den;
skip foo;
L [0]=foo*den(foo)-1;
#call series(expand,den)
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
   #call series(expand,log)
endargument;
#call series(expand,exp)
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
#call series(setFunctionNames,power = power)
skip foo;
L [0]=power(power(foo,-2),-1/2)-foo;
argument power;
   #call series(expand,power)
endargument;
argument power;
   id exp( - 2*log(ep^-2*c))=(ep^-2*c)^-2;
endargument;
#call series(expand,power)
id exp( - 1/2*log(ep^4*c^-2))=ep^-2*c;
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test7: local expansion variable
.sort
s x;
cf den;
skip foo;
l [0x] = 1-(1-x)*den(1-x);
l [0ep] = 1-(1-ep)*den(1-ep);
#call series(expand,den,x,{`CUT'-1})
#call series(expand,den)
.sort
drop [0x],[0ep];
#if (termsin([0x])>0) || (termsin([0ep])>0)
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test8: products of denominators
.sort
cf den;
skip foo;
L [0]=den(foo)*den(foo)-den(foo*foo);
#call series(expand,den)
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test9: products of exponentials
.sort
cf exp;
skip foo;
L [0]= exp(foo)*exp(-foo) - 1;
#call series(expand,exp)
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test10: products of logarithms
.sort
cf log;
skip foo;
L [0]= log(1+c*x)*log(1+d0*x) - c*d0*x^2;
#call series(expand,log,x,2)
#call series(expand,log,x,2)
id log(1) = 0;
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test11: products of powers
.sort
cf pow;
#call series(setFunctionNames,power = pow)
skip foo;
L [0]= 1 - pow(foo,foo)*pow(foo,-foo);
#call series(expand,pow)
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test12: products of Gamma functions
.sort
cf Gamma;
skip foo;
L [0]= 1 - Gamma(1+c*x)*Gamma(1-c*x);
#call series(expand,Gamma,x,1)
#call series(expand,Gamma,x,1)
id Gamma(1) = 1;
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test13: multiple denominators with poles
.sort
skip foo;
L [0]= x*den(x)^2 - 1/x;
#call series(expand,den,x,-1)
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test14: nontrivial normalisation
.sort
s A,a,c;
skip foo;
L [0] = (
   + den(A - a + c*x^2)* den(A + a + c*x^2)
   + den( - a + A)^2*den(a + A)*c*x^2
   - den( - a + A)*den(a + A)
   + den( - a + A)*den(a + A)^2*c*x^2
);
#call series(expand,den,x,2)
.sort
drop [0];
#if termsin([0])>0
   #message FAILED
   #redefine FAIL "{`FAIL'+1}"
   #else
   #message passed
#endif

#message Test15: nontrivial normalisation
.sort
skip foo;
L [0] = (
   + den(1 + c*x^2*den(A - a))* den(1 + c*x^2*den(A + a))
   - 1 + c*x^2*(den(A - a) + den(A + a))
);
#call series(expand,den,x,2)
print+s;
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
