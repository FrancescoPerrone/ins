% Draft of a new transition system
:- module(trans, [goal/2, transient/4]).

% NOTE: initial states are defined in initial.pl

% (non-avid case)
% states agents would welcome
good([1,1,1]).
good([1,0,1]).
% states agents should avoid
bad([0,1,0]).  
bad([0,0,0]).


% acsystem-based transition
transient(Init, Ac, Label, New):-
    precon(Ac, Init),
    perf(Init, New, Ac),
    compare(Init, New, ValH, ValC),
    Label = [ValH,ValC].

% perform a comparison between subsequent states
% from the standpoint of carla and hal set of values.
compare(ListA, ListB, LabA, LabB):-
    extrap(ListA, Ha, Ta),
    extrap(ListB, Hb, Tb),
    eval(hal, Ha, Hb, LabA),
    eval(carla, Ta, Tb, LabB).

extrap(List, A, B):-
    List = [A|[B]].

% goal state (refinement of Bench-Capon's (2006))
goal(G, Val):-
    state(G), good(G),
    Val = +life.
