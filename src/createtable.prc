*creates a new table [:`tab'] with size *at least* `SIZE'
#procedure createtable(tab,SIZE)

   #ifndef `$size`tab''
*  table is unused, create it
      table,sparse [:`tab'](1);
      #else
      cleartable [:`tab'];
   #endif
   #$size`tab'=`SIZE';

#endprocedure
