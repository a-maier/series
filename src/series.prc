* main procedure
* the first argument specifies the action (e.g. init or expand)
* all remaining arguments are forwarded to that action
#procedure @series(ACTION, ?ARGS)

   #call `ACTION'(`?ARGS')

#endprocedure
