agent(hal).
agent(carla).

%% Describe conditions for atoms be a representation of
%% possible world
state([I, M, A, W]):-
    member(I, [1, 0]),
    member(M, [2, 1, 0]),
    member(A, [2, 1, 0]),
    member(W, [1, 0]).

%% Describe a template for representing a particular
%% possible world, subset of all possible worlds
%% using the predicate "restriction"
world(State-Ag):-
    state(State),
    agent(Ag),
    restriction(State).

%% Assign insulin a value
insulin(State, Val):-
    State = [I, _, _, _],
    I = Val.

%% Assign alive a value
alive(State, Val):-
    State  = [_, _, A, _],
    A = Val.

%% Assign money a value
money(State, Val):-
    State  = [_, M, _, _],
    M = Val.

%% Assign time a value
time(State, Val):-
    State  = [_, _, _, T],
    T = Val.

%% Specify a restriction on the set of possible worlds.
restriction(State):-
    state(State),
    insulin(State, 1) -> alive(State, 2).
restriction(State):-
    state(State),
    insulin(State, 0) -> alive(State, Val),
    member(Val, [1,0]).

%% Definition for action lose
action(State-Ag, lose):-
    agent(Ag),
    world(State-Ag),
    insulin(State, 1).

%% applyLose(State-Ag, State2-Ag):-
%%     lose(State-Ag) -> world(State2-Ag), insulin(State2, 0).

action(State-Ag, compensate):-
    agent(Ag),
    world(State-Ag),
    money(State, M), member(M, [1,2]),
    insulin(State, 1).

%% Definition for action take
action(State-Ag, take):-
    agent(Ag),
    world(State-Ag),
    insulin(State, 0),
    alive(State, A), member(A, [1,2]).

%% Definition for action buy
%% Notice: here I'm following strictly what the paper
%% says about the possibility for an agent to buy insulin.
%% Therefore, considering the restriction on the possible worlds
%% an agent can only buy insulin if the agent is in urgent need
%% (alive(State, 1)) of insilin. This is because, according to the
%% restriction, for an agent to have 0 insulin means is life is at
%% risk (alive is 1) and an agent can only buy insulin if the agent
%% does not have insulin.
action(State-Ag, buy):-
    agent(Ag),
    world(State-Ag),
    money(State, M), member(M, [1,2]),
    time(State, 1),
    insulin(State, 0),
    not(alive(State, 0)).


%% Definition for action do_nothing
action(State-Ag, doNothing):-
    world(State-Ag),
    alive(State, A), member(A, [2,1,0]).

%% Other actions.
%% The following definition explicitely take into
%% consideration the state of affairs of both
%% agent involved in the action.

%% Definition for action compensate
action2ag(State-Ag-State2-Ag2, compensate):-
    agent(Ag),
    agent(Ag2),
    not(Ag = Ag2),
    world(State-Ag),
    world(State2-Ag2),
    money(State, M), member(M, [1,2]),
    insulin(State, 1),
    alive(State2, A), member(A, [1,2]).

%% Definition for action take
action2ag(State-Ag-State2-Ag2, take):-
    agent(Ag),
    agent(Ag2),
    not(Ag = Ag2),
    world(State-Ag),
    world(State2-Ag2),
    insulin(State, 0),
    alive(State, A), member(A, [1,2]),
    insulin(State2, 1).

%% Finite non empty set of possible state.
%% Notice: the set contains all possible worlds
%% taken with their restriction.
%% This is more a subset of the set of all possible worlds.
q(States):- findall(Ag-State, world(State-Ag), States),
	    X = [quoted(true), portray(true), 
		 max_depth(100), 
		 spacing(next_argument)],
	    set_prolog_flag(toplevel_print_options, X).

%% Action precondition function
%% For each action defines the set of states from which
%% it can be executed.
rho(Ag-Set, Action):-
    agent(Ag),
    findall(States, action(States-Ag, Action), Set),
    X = [quoted(true), portray(true),
	max_depth(100),
	spacing(next_argument)],
    set_prolog_flag(toplevel_print_options, X).
