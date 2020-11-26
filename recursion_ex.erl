%link: https://drive.google.com/file/d/1nUA2RM4Hf-u6NtnE8Wi47xBbYSelvV5A/view?usp=sharing
-module(recursion_ex).
-compile(export_all).

%	A=[4,6,8,1,5].
%	AA=[4,6,8,a,4].
%	B=[{1,2},{7,5},{6,4}].
%	C=[{3,1},{2,5},{3,5},{4,7},{8,4}].
%	D=[{2,5},{5,4},{3,8},{9,1}].
%	E=[{2,4},{3,f},{g,6},4,s,{4,7},{g,y},{9,3}].
%	G=[{2,4},{f,5},{4,h},{6,8},{8,3},{g,e}].
%	F=[d,g,s,s,we,v].
%	K=[{g},{w},{5}].

head([H|_]) -> H.
tail([_|T]) -> T.
max2Num(A,B) when (is_number(A) and is_number(B)) ->
	if A>B -> A;
	true -> B
	end;
max2Num(_,_) -> none.
min2Num(A,B) when (is_number(A) and is_number(B)) ->
	if A<B -> A;
	true -> B
	end;
min2Num(_,_) -> none.

%Exercise 1: Find Max List N Number
max([A]) -> A;
max(List) -> 
	case is_list(List) of
		true -> max2Num(head(List),max(tail(List)));
		false -> none
	end.

%Exercise 2: Find Min List N Number
min([A]) -> A;
min(List) ->
	case is_list(List) of
		true -> min2Num(head(List),min(tail(List)));
		false -> none
	end.

%Exercise 3:
% A.
headTuple([H|_]) when is_tuple(H) -> H;
headTuple([H|_]) when (not is_tuple(H)) -> [].

increasing({X,Y}) when (is_number(X) and is_number(Y))->
	if X<Y -> [{X,Y}];
	true -> ""
	end;
increasing({_,_}) -> "";
increasing(ListTuple) when ListTuple=/=[] ->
	increasing(headTuple(ListTuple)) ++ increasing(tail(ListTuple));
increasing(ListTuple) when ListTuple==[] -> "".

% B.
headPair([H|_]) when is_tuple(H) -> H;
headPair([H|_]) when (not is_tuple(H)) -> {}.
maxPair({X,Y}) when (is_number(X) and is_number(Y)) -> Y;
maxPair([]) -> none;
maxPair(ListTuple) when is_list(ListTuple) -> 
	case ListTuple of
		[{_,Val}] -> 	if is_number(Val)==true -> Val;
					true -> none
				end;
		_ -> max2Num( maxPair(headPair(ListTuple)), maxPair(ListTuple--[head(ListTuple)]) )
	end;

maxPair(ListTuple) when (not is_list(ListTuple)) -> none.

changePairs(List) -> 
	MaxPair= maxPair(List),
	case MaxPair of
		none -> io:fwrite("Wrong data type!~n");
		_ -> lists:map(fun({X,_}) -> {X,MaxPair} end, List)
	end.

%Excerise 4:
sale(N) -> (N+31) rem 7 + (N+1) rem 5.
%A.
saleIsZero(N) when (not is_integer(N)) -> io:format("Wrong data type!!~n");
saleIsZero(N) when is_integer(N) ->
	if 	N==0 -> [];
		N<0 -> io:format("Wrong!!~n");
		true ->
			case sale(N) of
				0 -> saleIsZero(N-1) ++ [N];
				_ -> saleIsZero(N-1)
			end
	end;
saleIsZero(N) when N<0 -> io:format("Wrong!!~n").

saleHigher(N,S) when ((not is_integer(N)) or (not is_number(S))) -> io:format("Wrong data type!~n");
saleHigher(N,S) when (is_integer(N) and is_number(S)) ->
	if N<0 -> io:format("Wrong N=~p~n",[N]);
	true ->
		Tmp = sale(N)-S,
		if N==0 -> 
			if Tmp > 0 -> [N];
			true -> []
			end;
		true ->
			if Tmp > 0 -> saleHigher(N-1,S)++[N];
			true -> saleHigher(N-1,S)
			end
		end
	end.

%C
%true: all sales are 0
%false: the other
allZeroPeriod(N) when N<0 -> io:format("Wrong!!~n");
allZeroPeriod(N) when N==0 -> sale(N)==0;
allZeroPeriod(N) when N>0 ->
	(case sale(N) of
		0 -> true;
		_ -> false
	end) and allZeroPeriod(N-1).

%D
% Ex: saleMax(10,{}). => 3
tailOfTuple({_,Y})->Y.
headOfTuple({X,_})->X.

max2(Val1,Val2) -> 
	if Val1 > Val2 -> Val1;
	true-> Val2
	end.

getListSale(N) ->
	if N==0 -> [{sale(N),N}];
	true -> [{sale(N),N}]++getListSale(N-1)
	end.

maxList([]) -> {};
maxList(List) -> max2(headPair(List),maxList(List--[headPair(List)])).

%this function return list of week which had the maximun sales:
saleMax(N) when (not is_integer(N)) -> io:format("Wrong data type~n");
saleMax(N) when is_integer(N) ->
	if N<0 -> io:format("N must not negative!!~n"); 
	true -> 
		Foo=getListSale(N),
		Max=headOfTuple(maxList(Foo)),
		lists:foldl(
			fun({X,Y}, Acc) -> 
				if (Max==X) -> [Y | Acc];
				true -> Acc 
				end
			end, [], Foo)
	end.

%Exercise 4: Divide list into many list; each list include 3 elements.
%Input : List A
%Output :
%+ list B, C if list A has more than 3 elements
%+ list B, C, D if list A has more than 6 elements
%+ .....
% =>
getThreeFirst([A,B,C|_]) -> [A,B,C].
divideList(List) when (not is_list(List)) -> io:format("Wrong data type!~n");
divideList(List) when is_list(List) ->
	case List of
		[_,_] -> [List];
		[_] -> [List];
		[] -> List;
		_ -> [getThreeFirst(List)]++divideList(List--getThreeFirst(List))
	end.
