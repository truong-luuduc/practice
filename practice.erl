%%Practice exercise on Erlang Programming
%Link: https://drive.google.com/file/d/1TetLQhT3WV9PwEiFTyX3UaF--9X0O0a0/view?usp=sharing
-module(practice).
-compile(export_all).

%Exercise 3-1: Evaluating Expressions

%% Write a function sum/1 which, given a positive integer N, will return the sum of all the
%% integers between 1 and N.

sum(N) when (not is_integer(N)) -> io:fwrite("Wrong data type~n");
sum(N) when is_integer(N) ->
	if N>0 -> N+sum(N-1);
	   N==0 -> 0;
	   true -> io:fwrite("N must positive~n")
	end.

%% Write a function sum/2 which, given two integers N and M, where N =< M, will return
%% the sum of the interval between N and M. If N > M, you want your process to terminate
%% abnormally.
sum(N,M) when ((not is_integer(N)) or (not is_integer(M))) -> io:fwrite("Wrong data type~n");
sum(N,M) ->
	if N=<M -> trunc((M-N+1)*(M+N)/2); %tong cac so tu N den M
	   true -> io:fwrite("Wrong~n")
	end.

%%Exercise 3-2: Creating Lists

%% Write a function that returns a list of the format [1,2,..,N-1,N] .gjfjfhfgghghfg
create(N) when (not is_integer(N)) -> io:fwrite("Wrong data type~n");
create(N) when is_integer(N) ->
	if N>0 -> create(N,[]);
	   true -> io:fwrite("Wrong~n")
	end.

create(0,Acc) -> Acc;
create(N,Acc) -> create(N-1,[N]++Acc).

%% Write a function that returns a list of the format [N , N-1,..,2,1] .
reverse_create(N) when (not is_integer(N)) -> io:fwrite("Wrong data type~n");
reverse_create(N) when is_integer(N) ->
	if N==0 -> [];
	   N>0 -> [N|reverse_create(N-1)];
	   true -> io:fwrite("Wrong~n")
	end.

%%Exercise 3-3: Side Effects

%%Write a function that prints out the integers between 1 and N.
%%Hint: use io:format("Number:~p~n",[N]) .
%not done
print(N) when (not is_integer(N)) -> io:fwrite("Wrong data type~n");
print(N) when is_integer(N) ->
	if N=<0 -> io:fwrite("Wrong~n");
	   true -> print_tail(N,0)
	end.

print_tail(1,Acc) -> Acc;
print_tail(N,Acc) -> 
	io:format("Number: ~p~n",print_tail(N-1,Acc+1)),
	print_tail(N-1,Acc+1).

%%Write a function that prints out the even integers between 1 and N.
even(N) when (not is_integer(N)) -> io:format("Wrong data type!~n");
even(N) when (N<0) -> io:format("Wrong data!~n");
even(N) when is_integer(N) -> even(N,[]).
even(0,Acc) -> Acc;
even(N,Acc) ->
	if (N rem 2 == 0) -> even(N-1,[N|Acc]);
	true -> even(N-1,Acc)
	end.
