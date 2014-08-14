% Draft of a new transition system
:- module(ntrans, [goal/2]).

% the goal state
good([1,_,1]).
% state to avoid
bad([0,_,0]).  
    

% Actions preconditions (single agent)

precon(buy, [0,1,1]).
precon(compensate, [1,1,1]).
precon(doNothing, _).
precon(doNothing, [_,_,0]).
precon(lose, [1,_,_]).
precon(take, [0,_,1]).

% Action preconditions (coalition)

cprecon(buy, [0,1,1], _).
cprecon(compensate, [1,1,1], [0,_,1]).
cprecon(doNothing, _, _).
cprecon(doNothing, [_,_,0], _).
cprecon(lose, [1,_,_], _).
cprecon(take, [0,_,1], [1,_,_]).

% Rules

% goal state (refinement of Bench-Capon's (2006))

goal(G, Val):-
    state(G), good(G),
    Val = +life.

% Transitions

