*computes BASE^EXP, treating both as series (as specified by the procedure series)
* the result is saved in `TARGET'
#procedure power(BASE,EXP,TARGET)

*uses TARGET=exp(EXP*log(BASE))

   #call log(`BASE',[:tmp_pow])
   skip;
*  #call multiply(`EXP',[:tmp_pow],[:tmp_pow_2])
*  skip;
   drop [:tmp_pow];
   L [:tmp_pow_2]=`EXP'*[:tmp_pow];
   #call exp([:tmp_pow_2],`TARGET')
   skip;
   drop [:tmp_pow_2];
   .sort

#endprocedure
