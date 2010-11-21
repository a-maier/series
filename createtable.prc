#procedure createtable(tab,SIZE)
*creates a new table [:`tab'] with size *at least* `SIZE'

	#ifndef `$size`tab''
*table is unused, create it
		table,sparse [:`tab'](1);
		#else
		cleartable [:`tab'];
	#endif
	#$size`tab'=`SIZE';
* *reset all entries to 0
* 	#do i=0,`SIZE'
* 		fill [:`tab'](`i')=0;
* 	#enddo


* 	#ifndef `$size`tab''
* *table is unused, create it
* 		#if `SERIESDEFAULTTABLESIZE'>`SIZE'
* 			table,zerofill [:`tab'](0:`SERIESDEFAULTTABLESIZE');
* 			#$size`tab'=`SERIESDEFAULTTABLESIZE';
* 			#else
* 			table,zerofill [:`tab'](0:`SIZE');
* 			#$size`tab'=`SIZE';
* 		#endif
* 		#else
* *table exists, reset all entries to 0
* 		#if `SIZE'>`$size`tab''
* 			#message WARNING: Table [:`tab'] is too small (size `$size`tab'', should be `SIZE')
* 			#message some terms may be lost
* 			#message to increase the table size, use #redefine SERIESDEFAULTTABLESIZE "`SIZE'"
* 		#endif
* 		#do i=0,`$size`tab''
* 			fill [:`tab'](`i')=0;
* 		#enddo
		
* 	#endif
#endprocedure
