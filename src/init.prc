#procedure init(CUT)

   #if exists($labelnum) == 0
      #$maxtermnum=`CUT';
      #$labelnum=0;
      S [:x],[:y],[:i];
      cf [:log],[:den],[:inv],[:Gamma],[:LOG],[:EXP];
      cf [:f];

      #if exists($derivative) == 0
         cf D;
         #$derivative = D;
      #endif

      #if exists($exponential) == 0
         cf exp;
         #$exponential = exp;
      #endif

      #if exists($gamma) == 0
         cf Gamma;
         #$gamma = Gamma;
      #endif

      #if exists($logarithm) == 0
         cf log;
         #$logarithm = log;
      #endif

      #if exists($polygamma) == 0
         cf psi;
         #$polygamma = psi;
      #endif

      #if exists($power) == 0
         cf pow;
         #$power = pow;
      #endif

      #if exists($denominator) == 0
         cf den;
         #$denominator = den;
      #endif

      table [:b](0:`CUT');
      #do n=0,`CUT'
	 #$a`n'=0;
	 #$b`n'=0;
	 fill [:b](`n')=$b`n';
      #enddo

*     just for convenience and to suppress warnings
      #$minterm=0;
      #$invminterm=0;
      #$minpow=0;
      #$c=0;
      #$lim=0;
      #$x=0;
      #$t=0;
      #$sum=0;
      #$origcut=0;
      #$varstore=0;
      #$cutstore=0;

   #elseif exists($IWarnedYou) == 0
      #message WARNING: init called more than once
      #message init was first called with argument `$maxtermnum'
      #message all further calls will be ignored
      #$IWarnedYou = 1;
   #endif

#endprocedure
