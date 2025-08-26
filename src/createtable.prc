*creates a new table [:`tab'] with size *at least* `SIZE'
#procedure createtable(tab,SIZE)

   #if exists($size`tab') == 0
*  table is unused, create it
      table,sparse [:`tab'](1);
   #else
      cleartable [:`tab'];
   #endif
   #$size`tab'=`SIZE';

#endprocedure
