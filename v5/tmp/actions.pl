:- module(actions, [actions/1, status/3, precon/2, perf/3, preconEx/3]).
%actions([buy, compensate, doNothing, lose, take]).

% the set of active actions
ac_actions([buy, compensate, doNothing, take]).

% the set of inactive actions
in_actions([doNothing]).

% action 'lose' has an undefined status
% it is neither active, nor passive...
other_ac([lose]).

% Actions preconditions
preconEx(Ac-Ag, Status, State-Ag):-
    status(Ag, X, Status),
    member(Ac, X),
    precon_aux(Ac, State).
    

% action precondition's auxiliary predicate
precon_aux(buy, [0,1,1]).
precon_aux(compensate,[1,1,1]).
precon_aux(lose, [1,0,1]).
precon_aux(lose, [1,1,1]).
precon_aux(take, [0,1,1]).
precon_aux(take, [0,0,1]).
precon_aux(doNothing, State):- 
    state(State).

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

status(Ag, Ac, active):-
    agent(Ag),
    ac_actions(Ac).

status(Ag, Ac, passive):-
    agent(Ag),
    in_actions(Ac).

status(Ag, Ac, super):-
    agent(Ag),
    actions(Ac).
