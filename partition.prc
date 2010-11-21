#procedure partition(SIZE)
* helper procedure for the other series procedures
* generates partitions for all number up to `SIZE' 
*#+
	CF [:c];
	#ifndef `$partitiontablesize'
*no partition table yet, initialise
		table,sparse [:partition](1);
		#$partitiontablesize=`SIZE';
* read precomputed table of partitions
		#include- partition.tbl
*		#$filllimit=0;
	#endif

	#if `$filllimit'<`SIZE'
*we have not inserted all table elements yet. The rest has to be computed manually 
*(this algorithm is quite stupid)
		#message partition table is incomplete. 
		#message elements {`$filllimit'+1} to `SIZE' will be computed dynamically
		#message to avoid dynamical computation run
		#message form -d SIZE=`SIZE' gen_partition_table.frm
		
		S [:x],[:y],[:z];
		CF [:part];
		skip;
* [partition](i,j) generates all partitions of i with largest element j
		L [:tmp]=
		#do i={`$filllimit'+1},`SIZE'
			+[:part](`i',`i')*[:x]^`i'
		#enddo
		;

		repeat id once [:part]([:x]?{>0},[:y]?)=sum_([:z],1,min_([:x],[:y]),[:c]([:z],1)*[:part]([:x]-[:z],[:z]));
		id once [:part](0,[:x]?)=1;
		repeat id [:c]([:x]?,[:y]?)*[:c]([:x]?,[:z]?)=[:c]([:x],[:y]+[:z]);
*inverse factorials
		id [:c]([:x]?,[:y]?{>1})=invfac_([:y])*[:c]([:x],[:y]);
		b [:x];
		.sort
		#$filllimit=`SIZE';
		fillexpression [:partition]=[:tmp]([:x]);
		drop [:tmp];
	#endif
#endprocedure
