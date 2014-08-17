% Draft of a new transition system
:- module(trans, [goal/2, transition/1]).

% active(hal).
% passive(carla).

/*

act(Ag, Ac):-
    active(Ag),
    act_acts(Ac).

inact(Ag, Ac):-
    passive(Ag),
    pas_acts(Ac).

*/

% (non-avid case)
% ---------------------------
% state agents would welcome
good([1,1,1]).
good([1,0,1]).
% state agents will avoid
bad([0,1,0]).  
bad([0,0,0]).

actions([buy, compensate, doNothing, lose, take]).

active(Ag, Ac):-
    agent(Ag),
    act_acts(Ac).

passive(Ag, Ac):-
    agent(Ag),
    pas_acts(Ac).

act_acts([buy, compensate, doNothing, take]).
pas_acts([doNothing]).

affects(compensate, carla).
affects(take, carla).
%affects(Ac, Ag):- passive(Ag), act_actions(Set), member(Ac, Set).
    
% Actions preconditions (single agent)
sprecon(buy, [0,1,1]).
sprecon(compensate,[1,1,1]).
sprecon(lose, [1,0,1]).
sprecon(lose, [1,1,1]).
sprecon(take, [0,1,1]).
sprecon(take, [0,0,1]).
sprecon(doNothing, State):- state(State).

% Single agent's action performance
sperf([0,1,1], [1,0,1], buy).
sperf([1,1,1], [1,0,1], compensate).
sperf([1,M,A], [0,M,A], lose).
sperf([0,M,1], [1,M,1], take).
sperf(Init, New, doNothing):-
    sprecon(doNothing, Init),
    state(Init), state(New),
    Init = [I, M, A],  New = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).

% Coalition actions' precondition
% precon(Action,[ActiveA,PassiveA]).
precon(take,[[0,1,1],[1,1,1]]).
precon(take,[[0,1,1],[1,0,1]]).
precon(take,[[0,0,1],[1,1,1]]).
precon(take,[[0,0,1],[1,0,1]]).
precon(compensate,[[1,1,1],[0,0,1]]).
precon(compensate,[[1,1,1],[0,1,1]]).
precon(buy,[[0,1,1], State]):- state(State).
precon(lose,[[1,1,1],[State]]):- state(State).
precon(lose,[[1,0,1],[State]]):- state(State).
precon(doNothing, [StateA, StateP]):- state(StateA), state(StateP).

% Coalition's action performance
% perf([InitA,InitP], [NextA,NextP], Action).
perf([[0,1,1],[1,1,1]], [[1,1,1],[0,1,1]], take).
perf([[0,1,1],[1,0,1]], [[1,1,1],[0,0,1]], take).
perf([[0,0,1],[1,1,1]], [[1,0,1],[0,1,1]], take).
perf([[0,0,1],[1,0,1]], [[1,0,1],[0,0,1]], take).
perf([[1,1,1],[0,0,1]], [[0,1,1],[0,1,1]], compensate).
perf([[1,1,1],[0,1,1]], [[0,1,1],[0,1,1]], compensate).
perf([[0,1,1],[State]], [[1,1,1],[State]], buy):- state(State).
perf([[1,1,1],[State]], [[0,1,1],[State]], lose):- state(State).
perf([[1,0,1],[State]], [[0,0,1],[State]], lose):- state(State).
perf([InitA, InitP], [NextA, NextP], doNothing):- 
    sperf(InitA, NextA, doNothing), 
    sperf(InitP, NextP, doNothing).

% transient([[],[]], []-[], [[],[]]).
transient(Init, Act-Label, Next):-
    precon(Act, Init),
    perf(Init, Next, Act),
    compare(Init, Next, Val1, Val2),
    Label = [Val1, Val2].

compare(ListA, ListB, LabA, LabB):-
    extrap(ListA, Ha, Ta),
    extrap(ListB, Hb, Tb),
    eval(hal, Ha, Hb, LabA),
    eval(carla, Ta, Tb, LabB).

extrap(List, A, B):-
    List = [A|[B]].

transition(Init-Label-New):-
    initial(Init),
    transient(Init, Label, New).

% goal state (refinement of Bench-Capon's (2006))
goal(G, Val):-
    state(G), good(G),
    Val = +life.
