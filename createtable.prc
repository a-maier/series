#procedure createtable(tab,SIZE)
*creates a new table [:`tab'] with size *at least* `SIZE'

   #ifndef `$size`tab''
*  table is unused, create it
      table,sparse [:`tab'](1);
      #else
      cleartable [:`tab'];
   #endif
   #$size`tab'=`SIZE';

#endprocedure
