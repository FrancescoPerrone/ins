% Draft of a new transition system
:- module(trans, [goal/2, transition/1]).


% NOTE: initial states are defined in initial.pl

% (non-avid case)
% states agents would welcome
good([1,1,1]).
good([1,0,1]).
% states agents should avoid
bad([0,1,0]).  
bad([0,0,0]).
    
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
