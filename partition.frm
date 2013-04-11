#procedure nextPartition(N,PART)
*   compute the next integer partition for N
*   the current partition is given by ($`PART'1,...,$`PART`$`PART'SIZE'')
*   initially $`PART'SIZE should be set to 0
*   the new partition will again be saved to 
*   ($`PART'1,...,$`PART`$`PART'SIZE'')

   #if `$`PART'SIZE' == 0
*     initial partition
      #$`PART'SIZE = 1;
      #$`PART'1 = `N';
      #$`PART'2 = 0;
      
      #elseif `$`PART'1' == 1
*     last partition
      #$`PART'SIZE = 0;
      #$`PART'1 = 0;
      
      #else
*     next partition:
*     subtract 1 from an element e1
*     and add 1 to the next element e2 which is smaller than e1-1
*     if no such element e2 exists, add a 1 as a new element
*     e1 is chosen in such a way that the partition is still
*     sorted (in descending order) after this operation
      #do i=1,`$`PART'SIZE'
	 #if `$`PART'`i'' >  `$`PART'{`i'+1}'
	    #$`PART'`i' = {`$`PART'`i''-1};
	    #do j={`i'+1},{`$`PART'SIZE'+1}
	       #if `$`PART'`j'' < `$`PART'`i''
		  #$PART`j' = {`$`PART'`j''+1};
		  #breakdo
	       #endif
	    #enddo
*           check whether we just added a new element to the partition
	    #if `$`PART'{`$`PART'SIZE'+1}' > 0
	       #$`PART'SIZE = {`$`PART'SIZE'+1};
	       #$`PART'{`$`PART'SIZE'+1} = 0;
	    #endif
	    #breakdo
	 #endif
      #enddo
   #endif
#preout off

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
