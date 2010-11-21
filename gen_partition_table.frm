*generate partition tables for use with the series package
#-
off stats;

#ifndef `SIZE'
#message usage: form -d SIZE=[number] gen_partition_table.frm
#terminate
#endif

#include- series.h
#call partition(`SIZE')
#write <partition.tbl> "#$seriesfilllimit=`SIZE';"
printtable [series::partition] >> partition.tbl ;
.end
