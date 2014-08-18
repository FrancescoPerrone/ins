:- module(actions, [actions/1, status/3, precon/2, perf/3]).
%actions([buy, compensate, doNothing, lose, take]).

% actions can be active/passive
ac(active, [buy, compensate, doNothing, take]).
ac(passive, [doNothing, buy]).
% however, 'lose' does not have a classification
ac(super, [lose]).

% agent can be active/passive
% according to their status they can parform actions
status(hal, active).
status(carla, passive).

actions(Ag, Actions):-
    agent(Ag),
    can_perf(Ag, Actions).

can_perf(Ag, Actions):-
    status(Ag, Status),
    ac(Status, Actions).


% Single agent's action performance
sperf([0,1,1], [1,0,1], buy).
sperf([1,1,1], [1,0,1], compensate).
sperf([1,M,A], [0,M,A], lose).
sperf([0,M,1], [1,M,1], take).
sperf(Init, New, doNothing):-
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

actions(Set):-
    ac_actions(AcSet),
    in_actions(InSet),
    other_ac(Oth),
    setof(Ac, (member(Ac, AcSet); member(Ac, InSet); member(Ac, Oth)), Set).

% the status of an agent is given by the set of action
% the agent can perform

% Parameters
% Ag: an agent
% Ac: a set of action
% Status: active, passive or super

