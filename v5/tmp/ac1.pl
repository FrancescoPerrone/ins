:- module(acsystem, [precon/2,perf/3, label/3]).

% action preconditions

% precon(Action [[Hal State], [Carla State])

precon(compensate,[[1,1,1], [1,1,1]]).
precon(take,[[0,1,1], [1,1,1]]).
precon(take,[[0,1,1], [1,0,1]]).
precon(take,[[0,0,1], [1,1,1]]).
precon(take,[[0,0,1], [1,0,1]]).

precon(buy, [[0,1,1], State]):-  
    state(State).

precon(doNothing, [State1, State2]):- 
    state(State1), 
    state(State2).

perf([[1,1,1], [1,1,1]],[[1,0,1],[1,1,1]], compensate).
perf([[0,1,1], [1,1,1]],[[1,1,1],[0,1,1]], take).
perf([[0,1,1], [1,0,1]],[[1,1,1],[0,0,1]], take).
perf([[0,0,1], [1,1,1]],[[1,0,1],[0,1,1]], take).
perf([[0,0,1], [1,0,1]],[[1,0,1],[0,0,1]], take).

perf([[0,1,1], [I,M,A]],[[1,0,1],[I,M,A]], buy).

perf([Init, [I,M,A]], [New, [I,M,A]], doNothing):-
    state(Init), state(New),
    Init = [Ii, Mi, Ai],  New = [Ii, Mi, An], 
    (
	(Ai = 1, Ii = 0) *-> An = 0;
	An = Ai
    ).

label(Init, New, L):-
    compare(Init, New, ValH, ValC),
    L = [ValH,ValC].
    
% compares two states from the standpoint of 
% carla and hal set of values.
compare(ListA, ListB, LabA, LabB):-
    extrap(ListA, Ha, Ta),
    extrap(ListB, Hb, Tb),
    eval(hal, Ha, Hb, LabA),
    eval(carla, Ta, Tb, LabB).

% auxliary predicate for compare. 
extrap(List, A, B):-
    List = [A|[B]].
