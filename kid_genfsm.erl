-module (kid_genfsm).
-behaviour (gen_fsm).
% -compile(export_all).

%% API
-export([start_link/2, stop/1]).
-export([grow/1, feed/1, egg/1]).
%% gen_fsm callbacks
-export([init/1,
	growing/2,
	flying/2,
	chasing/2,
       	handle_event/3,
       	handle_sync_event/4,
       	handle_info/3,
       	terminate/3,
       	code_change/4]).

-define(SERVER, ?MODULE).


%%%===================================================================
%%% API
%%%===================================================================

stop(BirdName) ->
        gen_fsm:send_all_state_event(BirdName, stop).

grow(BirdName) ->
        gen_fsm:send_event(BirdName, grow).

feed(BirdName) ->
        gen_fsm:send_event(BirdName, feed).

egg(BirdName) ->
        gen_fsm:send_event(BirdName, egg).
	%old: egg() -> gen_fsm:send_event(?SERVER, egg).
	% etc feed(), grow(), stop()


%%===================================================================
%% gen_fsm call back
%%===================================================================
start_link(BirdName, Food) ->
    gen_fsm:start_link({local, BirdName}, ?MODULE, [BirdName, Food], []).
    %gen_fsm:start_link({local, ?MODULE}, ?MODULE, [BirdName, Food], []).

  init([BirdName, Food]) ->
      %% To know when the parent shuts down
      %process_flag(trap_exit, true),
      %% sets a seed for random number generation for the life of the process
      %% uses the current time to do it. Unique value guaranteed by now()
      random:seed(now()),
      TimeToPlay = random:uniform(10000),
     % StrRole = atom_to_list(Food),
      io:format("Bird ~s, eating the ~s .~n",
                [BirdName, Food]),
      {ok, growing, [BirdName], TimeToPlay}.

growing(Event, StateData) ->
      case Event of
        feed->
          io:format("Bird ~p is Flying~n",[StateData]),
	  io:format("Next state: Flying~n~n"),
          {next_state, flying, StateData, 50000};
        timeout ->
          io:format("Bird ~p is Chasing~n",[StateData]),
 	  io:format("Next state: Chasing~n~n"),
          {next_state, chasing, StateData, 5000};
        _->
          io:format("Bird ~p is Growing~n",[StateData]),
	  io:format("Next state: Growing~n~n"),
          {next_state, growing, StateData, 1000}
      end.

flying(Event, StateData) ->
          case Event of
            feed ->
              io:format("Bird ~p is Chasing~n",[StateData]),
 	      io:format("Next state: Chasing~n~n"),
              {next_state, chasing, StateData, 3000};
            timeout ->
              io:format("Bird ~p is Growing~n",[StateData]),
	      io:format("Next state: Growing~n~n"),
              {next_state, growing, StateData, 3000};
            _->
              io:format("Bird ~p is Flying~n",[StateData]),
	      io:format("Next state: Flying~n~n"),
              {next_state, flying, StateData, 1000}
          end.

chasing(Event, StateData) ->
                  case Event of
                    egg ->
                      io:format("Bird ~p is Growing~n",[StateData]),
	  	      io:format("Next state: Growing~n~n"),
                      {next_state, growing, StateData, 3000};
                    _->
                      io:format("Bird ~p is Chasing~n",[StateData]),
 	 	      io:format("Next state: Chasing~n~n"),
                      {next_state, growing, StateData, 3000}
                  end.

handle_event(stop, _StateName, StateData) ->
	io:format("~p~n",[element(1,list_to_tuple(StateData))]),
	io:format("Bird ~p    !!!STOP!!!~n",StateData),
        {stop, normal, StateData};
handle_event(_Event, StateName, StateData) ->
	
        {next_state, StateName, StateData}.

handle_sync_event(_Event, _From, StateName, StateData) ->
    Reply = ok,
    {reply, Reply, StateName, StateData}.

handle_info(_Info, StateName, StateData) ->
    {next_state, StateName, StateData}.

terminate(_Reason, _StateName, _StateData) ->
     io:format("This is terminal~n"),
    ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.
