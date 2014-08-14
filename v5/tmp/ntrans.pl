% Draft of a new transition system
:- module(ntrans, [goal/2]).

% state agents will welcome
good([1,_,1]).
% state agents will avoid
bad([0,1,0]).  
bad([0,0,0]).  
    

% Actions preconditions (single agent)

precon(buy, [0,1,1]).
precon(compensate, [1,1,1]).
precon(doNothing, [_,_,_]).
precon(doNothing, [_,_,0]).
precon(lose, [1,_,1]).
precon(take, [0,_,1]).

% Action preconditions (coalition)

cprecon(buy, [0,1,1], _).
cprecon(compensate, [1,1,1], [0,_,1]).
cprecon(doNothing, [_,_,_], _).
cprecon(doNothing, [_,_,0], _).
cprecon(lose, [1,_,1], _).
cprecon(take, [0,_,1], [1,_,_]).

% Rules

% goal state (refinement of Bench-Capon's (2006))

goal(G, Val):-
    state(G), good(G),
    Val = +life.

% Single agent's action performance

perf([0,1,1], [1,0,1], buy).
perf([1,1,1], [1,0,1], compensate).
perf([1,M,A], [0,M,A], lose).
perf([0,M,1], [1,M,1], take).
perf(Init, New, doNothing):-
    precon(doNothing, Init),
    state(Init), state(New),
    Init = [I, M, A],  New = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).

% Coalition's action performance
