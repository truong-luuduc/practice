-module(what_the_if).
-compile(export_all).

oh_god(N) ->
if N =:= 2 -> might_succeed;
true -> always_does  %% this is Erlang's if's 'else!'
end.

compair(A,B) when is_number(A), is_number(B) ->
   if
       A>B -> io:format("~p > ~p~n",[A,B]);
       A<B -> io:format("~p < ~p~n",[A,B]);
       true -> io:format("~p = ~p~n",[A,B])
   end;
compair(_A,_B) -> none.

help_me(Animal) ->
    Talk = if Animal == cat -> "meo meo";
              Animal == beef -> "mooo";
              Animal == dog -> "go go";
              Animal == monkey -> "ki kiki";
              true -> "abcabc"
           end,
    io:format("~p says ~p~n",[Animal,Talk]),
    {Animal, "say " ++ Talk ++ "!"}.

help_me2(Animal) ->
    Talk = case Animal of
		cat -> "meo meo";
		beef -> "moooo";
		dog -> "go go";
		monkey -> "ki ki";
		_ -> "abcabc"
	   end,
    io:format("~p says ~p~n",[Animal,Talk]),
    {Animal, "say " ++ Talk ++ "!"}.

tt(M)->
	if M<12 ; M==12 -> io:fwrite("true~n");
		true -> io:fwrite("false~n")
	end.

hh(M) ->
io:fwrite(M<12 orelse M==12).
