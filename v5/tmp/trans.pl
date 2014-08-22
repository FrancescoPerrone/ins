% Draft of a new transition system
:- module(trans, [goal/2, trans/5]).

% (non-avid case)
% states agents would welcome
good([1,1,1]).
good([1,0,1]).
% states agents should avoid
bad([0,1,0]).  
bad([0,0,0]).

trans(1, Init, Ac, L, New):-
    precon(Ac, Init),
    perf(Init, New, Ac),
    label(Init, New, L).

% goal state (refinement of Bench-Capon's (2006))
goal(G, Val):-
    state(G), good(G),
    Val = +life.
