#procedure init(CUT)

   #ifndef `$labelnum'
      #$maxtermnum=`CUT';
      #$labelnum=0;
      S [:x],[:y],[:i];
      cf [:log],[:den],[:Gamma],[:LOG],[:EXP];
      cf exp,log,D,psi,[:f];

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

      #else
      #ifndef `$IWarnedYou'
	 #message WARNING: init called more than once
	 #message init was first called with argument `$maxtermnum'
	 #message all further calls will be ignored
	 #$IWarnedYou = 1;
      #endif
   #endif

#endprocedure
