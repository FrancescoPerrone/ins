:- module(acsystem, [precon/2,perf/3]).

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

%% precon(lose,[[1,1,1], State]):-  
%%     state(State).
%% precon(lose,[[1,0,1], State]):-
%%     state(State).

% perform actions

% perf([],[], Action).
% perf([Hal State],[Carla State]],[[Hal State],[Carla State]], Action)

perf([[1,1,1], [1,1,1]],[[1,0,1],[1,1,1]], compensate).
perf([[0,1,1], [1,1,1]],[[1,1,1],[0,1,1]], take).
perf([[0,1,1], [1,0,1]],[[1,1,1],[0,0,1]], take).
perf([[0,0,1], [1,1,1]],[[1,0,1],[0,1,1]], take).
perf([[0,0,1], [1,0,1]],[[1,0,1],[0,0,1]], take).

%% perf([[1,1,1], State],[[0,1,1],State], lose).
%% perf([[1,0,1], State],[[0,0,1],State], lose).

perf([[0,1,1], State],[[1,0,1],State], buy):- 
    state(State).

perf([Init, State], [New, State], doNothing):-
    state(Init), state(New),
    state(State),
    Init = [I, M, A],  New = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).


