#procedure init(CUT)

.sort
#call partition(`CUT')
skip;
.sort
S [:x],[:y],[:z];
cf [:f],[:g],[:exp],[:log];
cf exp,log,D;
skip;
.sort

#endprocedure
