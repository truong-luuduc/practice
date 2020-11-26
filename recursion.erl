-module(recursion).
-compile(export_all).

fac(N) when N==0 -> 1;
fac(N) when N>0 -> N*fac(N-1).

len([]) -> 0;
len([_|T]) -> 1+ len(T).
%can caculate by call tail_fac(N,N-1).
%Ex: 5! = tail_fac(5,4).
tail_fac(N) -> tail_fac(N,1).
tail_fac(0,Acc) -> Acc;
tail_fac(N,Acc) when N>0 -> tail_fac(N-1,Acc*N).

tail_len(L) -> tail_len(L,0).
tail_len([_|T], Acc) -> tail_len(T,Acc+1);
tail_len([], Acc) -> Acc.

reverse([]) -> [];
reverse([H|T]) -> reverse(T)++[H].

tail_reverse(L) -> tail_reverse(L,[]).

tail_reverse([],Acc) -> 
	io:format("Acc1 = ~p~n",[Acc]),
	Acc;
tail_reverse([H|T],Acc) -> 
	io:format("Acc2 = ~p~n",[Acc]),
	tail_reverse(T, [H|Acc]).


