*generate partition tables for use with the series package
#-
off stats;

#ifndef `SIZE'
#message usage: form -d SIZE=[number] gen_first_partition_table.frm
#terminate
#endif

table,relax [series::partition](1:`SIZE');
S [:x],[:y],[:z];
CF [:part],[series::c];
skip;
* [partition](i,j) generates all partitions of i with largest element j
L [:tmp]=
#do i=1,`SIZE'
	+[:part](`i',`i')*[:x]^`i'
#enddo
;

repeat id once [:part]([:x]?{>0},[:y]?)=sum_([:z],1,min_([:x],[:y]),[series::c]([:z],1)*[:part]([:x]-[:z],[:z]));
id once [:part](0,[:x]?)=1;
repeat id [series::c]([:x]?,[:y]?)*[series::c]([:x]?,[:z]?)=[series::c]([:x],[:y]+[:z]);
*inverse factorials
id [series::c]([:x]?,[:y]?{>1})=invfac_([:y])*[series::c]([:x],[:y]);
b [:x];
.sort
fillexpression [series::partition]=[:tmp]([:x]);
drop [:tmp];
#write <partition.tbl> "#$seriesfilllimit=`SIZE';"
printtable [series::partition] >> partition.tbl ;
* .sort
* #system perl -i \'\' -we \'s/^Fill /^Fill,/;s/\s+//g\' partition.tbl
.end
