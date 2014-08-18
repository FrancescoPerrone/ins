:- module(actions, [actions/1, status/3, precon/2, perf/3]).

actions(hal, [buy, compensate, doNothing, lose, take]).
actions(carla, [buy, compensate, doNothing, lose, take]).

% joint actions for the scenarion were hal has lost his isnsulin
jaction([ [doNothing-hal, doNothing-carla], 
	  [take-hal, doNothing-carla],
	  [doNothing-hal, buy-carla],
	  [compensate-hal, doNothing-carla] ]).


% Single agent's action performance
perf([0,1,1], [1,0,1], buy).
perf([1,1,1], [1,0,1], compensate).
perf([1,M,A], [0,M,A], lose).
perf([0,M,1], [1,M,1], take).
perf(Init, New, doNothing):-
    precon_aux(doNothing, Init),
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
