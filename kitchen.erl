-module(kitchen).
-compile(export_all).
 
fridge1() ->
    receive
	{From, {store, _Food}} ->
		From ! {self(), ok},
		fridge1();
	{From, {take, _Food}} ->
		From ! {self(), not_found},
		fridge1();
	terminate ->
		ok
    end.

fridge2(FoodList) ->
    receive
	{From, {store, Food}} ->
		From ! {self(), ok},
		fridge2([Food|FoodList]);
	{From, {take, Food}} ->
		case lists:member(Food, FoodList) of
		true ->
			From ! {self(), {ok, Food}},
			fridge2(lists:delete(Food, FoodList));
		false ->
			From ! {self(), {not_found, Food}},
			fridge2(FoodList)
		end;
	terminate ->
		ok
    end.

store(Pid,Agr) ->
	%io:fwrite("Store ~p to fridge2~n",[Agr]),
	Pid ! {self(), {store,Agr}},
	receive
		{Pid, Msg} -> Msg
	end.

take(Pid,Agr) ->
	Pid ! {self(), {take,Agr}},
	receive
		{Pid, Msg} -> Msg
	end.
%	io:fwrite("Take ~p from fridge2~n",[Agr]).

call(Arg1, Arg2) -> 
   io:format("~p ~p~n", [Arg1, Arg2]). 

start(Agr) ->  %Ex: call by P1=kitchen:start([Agr1,Agr2,...]). remember Agrs in [..]
   spawn(?MODULE, fridge2, [Agr]).
