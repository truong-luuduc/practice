-module(test_ets).
-compile(export_all).
-record(person, {name, age, phone, email}).

create(Name) -> %create table Name
	ets:new(Name, [bag, named_table, {keypos,2}]). %default keypos=1

insert(Name, P=#person{}) -> %insert new object for table Name
	io:format("You're about to insert ~p into table ~p~n",[P#person.name, Name]),
	Index = len(ets:tab2list(Name))+1,
	ets:insert(Name, {Index, P#person.name, P#person.age, P#person.phone, P#person.email}),
	print(Name).  

search(Name, P=#person{}) -> %search name person P in Name, mean key 
	io:format("Search person ~p~n",[P#person.name]),
	ets:lookup(Name, P#person.name);

search(Name, Arg) -> %search key=_arg
	io:format("Search _arg~n"),
	ets:lookup(Name, Arg).

create_person() -> %return a person record
	#person{name=pick_name(), age=pick_age(), phone=pick_phone(), email=pick_email()}.

is_person(Arg) -> is_record(Arg, person). %check if Arg a is a person record

print(Table) -> %print list data in table
	io:format("Table is: ~p~n",[ets:tab2list(Table)]).

pick_age() -> %random age in 1..80
	random:uniform(80).

pick_phone() -> %random phone "0____"
	"0"	++ 
	lists:nth(random:uniform(10), num()) ++
	lists:nth(random:uniform(10), num()) ++
	lists:nth(random:uniform(10), num()) ++
	lists:nth(random:uniform(10), num()).

pick_email() -> %random email
    lists:nth(random:uniform(10), email())
    ++ lists:nth(random:uniform(3), domain()).

pick_name() -> %random name
    lists:nth(random:uniform(10), firstnames())
    ++ " " ++
	lists:nth(random:uniform(6), middlename())
    ++ " " ++
    lists:nth(random:uniform(10), lastnames()).

len([]) -> 0; %caculating length of list
len([_|T]) -> 1+ len(T).
%=========================================================================%
email() ->
	["hihi", "hehe", "keke", "kaka", "kiki", "muahaha", "haha", "huahua", "huahuata", "ahihi"].
domain() ->
	["@gmail.com", "@yahoo.com", "@outlock.com"].
firstnames() ->
    ["Nguyen", "Hoang", "Le", "Phan", "Pham",
     "Do", "Ngo", "Trinh", "Luu", "Tran"].
middlename() ->
	["Van", "Thi", "Duc", "Quoc", "Bao", "Thanh"].
lastnames() ->
    ["Auto", "Hai", "Truong", "Viet", "Nhan",
     "Long", "Hung", "Nga", "Lien", "Ly"].
num() ->
	["0","1","2","3","4","5","6","7","8","9"].

%=========================================================================%
%Data to test
%c(test_ets).
%rr(test_ets).
%P1=test_ets:person(ten, 23, 89393, mail1).
%P2=P1.
%P3=test_ets:person(ten, 12, 4333, mail3).
%P4=test_ets:person(ten4, 16, 123, mail4).
%test_ets:create(tab,P1).	=> true
%test_ets:search(tab,P1).	=> [{ten,23,89393,mail1}]
%test_ets:insert(tab,P2).	=> true ???? P2=P1, why?
%test_ets:insert(tab,P3).	=> true
%test_ets:insert(tab,P4).	=> true
%test_ets:search(tab,P1).	=> [P1 or P2, P3]   [{ten,23,89393,mail1},{ten,12,4333,mail3}]
%test_ets:search(tab,P2).	=> same above
%test_ets:search(tab,P3).	=> same above
%test_ets:search(tab,P4).	=> [{ten4,16,123,mail4}]
