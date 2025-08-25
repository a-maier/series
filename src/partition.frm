*   compute the next integer partition for N
*   the current partition is given by ($`PART'1,...,$`PART`$`PART'SIZE'')
*   initially $`PART'SIZE should be set to 0
*   the new partition will again be saved to
*   ($`PART'1,...,$`PART`$`PART'SIZE'')
#procedure nextPartition(N,PART)

   #if `$`PART'SIZE' == 0
*     first partition
      #call nextLongerPartition(`N',`PART')

      #elseif `$`PART'1' == 1
*     last partition
      #$`PART'SIZE = 0;
      #$`PART'1 = 0;

      #elseif `$`PART'1' == 2
      #call nextLongerPartition(`N',`PART')

      #else
*     next partition
*     try tro find a pair of elements which differ by more than 1
      #do i=2,{`$`PART'SIZE'+1}
	 #if `$`PART'`i'' < {`$`PART'1'-1}
	    #if `i' > `$`PART'SIZE'
	       #$`PART'SIZE = {`$`PART'SIZE'+1};
	       #$`PART'{`$`PART'SIZE'+1} = 0;
	    #endif
	    #define DIFF "1"
	    #$`PART'`i' = {`$`PART'`i''+1};
	    #do j=2,{`i'-1}
	       #redefine DIFF "{`DIFF'+`$`PART'`i''-`$`PART'`j''}"
	       #$`PART'`j' = `$`PART'`i'';
	    #enddo
	    #$`PART'1 = {`$`PART'1'-`DIFF'};
	    #breakdo
	 #endif
      #enddo
   #endif

#endprocedure

#procedure nextLongerPartition(N,PART)

   #define LENGTH "{`$`PART'SIZE'+1}"
   #$`PART'SIZE = `LENGTH';
   #$`PART'1 = {`N'-`LENGTH'+1};
   #do i=2,`LENGTH'
      #$`PART'`i' = 1;
   #enddo
   #$`PART'{`LENGTH'+1} = 0;

#endprocedure

#procedure computeMultiplicities(PART,MUL)

*   the multiplicity of any element e of the partition
*   ($`PART'1,...,$`PART`$`PART'SIZE'') will be saved to $`MUL'`i'

   #define N

   #do i=1,`$`PART'SIZE'
      #redefine N "`$`PART'`i''"
      #$`MUL'`N'=0;
   #enddo

   #do i=1,`$`PART'SIZE'
      #redefine N "`$`PART'`i''"
      #$`MUL'`N'= {`$`MUL'`N''+1};
   #enddo

#endprocedure
