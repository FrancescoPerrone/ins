:- module(acsystem, [precon/2,perf/3, label/3]).

% action preconditions

precon(buy,[0,1,1]).
precon(compensate,[1,1,1]).
precon(lose,[1,0,1]).
precon(lose,[1,0,1]).
precon(take,[0,1,1]).
precon(take,[0,1,1]).
precon(take,[0,0,1]).
precon(take,[0,0,1]).

precon(doNothing, State):- 
    state(State).

% post coditions

perf([0,1,1], [1,0,1], buy).
perf([1,1,1], [1,0,1], compensate).
perf([1,1,1], [0,1,1], lose).
perf([1,0,1], [0,0,1], lose).
perf([0,1,1], [1,1,1], take).
perf([0,0,1], [1,0,1], take).
perf([0,0,1], [1,0,1], take).

perf(Init, New, doNothing):-
    state(Init), state(New),
    Init = [I, M, A],  New = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).

label(Init, New, L):-
    eval(Ag, Init, New, L),
    agent(Ag), !.
