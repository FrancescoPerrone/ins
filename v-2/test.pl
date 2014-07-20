agent(hal).
agent(carla).

%% Describe conditions for atoms be a representation of
%% possible world
state([I, M, A, W]):-
    member(I, [1,0]),
    member(M, [2, 1, 0]),
    member(A, [2,1,0]),
    member(W, [1,0]).

%% Describe a template for representing a particular
%% possible world, subset of all possible worlds
%% using the predicate "restriction"
world(State-Ag):-
    state(State),
    agent(Ag),
    restriction(State).

insulin(State, Val):-
    State = [I, _, _, _],
    I = Val.

alive(State, Val):-
    State  = [_, _, A, _],
    A = Val.

money(State, Val):-
    State  = [_, M, _, _],
    M = Val.

time(State, Val):-
    State  = [_, _, _, T],
    T = Val.

restriction(State):-
    state(State),
    insulin(State, 1) -> alive(State, 2).
restriction(State):-
    state(State),
    insulin(State, 0) -> alive(State, Val),
    member(Val, [1,0]).



%% Other representation predicates
q(States):- findall(Ag-State, world(State-Ag), States),
	    X = [quoted(true), portray(true), 
		 max_depth(100), 
		 spacing(next_argument)],
	    set_prolog_flag(toplevel_print_options, X).
