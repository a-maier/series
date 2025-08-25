* Set the names for the different types of functions
* used by the series package.
*
* Each argument should be of the form <TYPE> = <NAME>,
* e.g. #call setFunctionNames(exponential = exp, logarithm = ln_)
*
* The predefined types and default values are
* denominator = den
* derivative = D
* exponential = exp
* gamma = Gamma
* logarithm = log
* polygamma = psi
* power = pow
#procedure setFunctionNames(?FUN)

   #do F={`?FUN'}
      #$`F';
   #enddo

#endprocedure
