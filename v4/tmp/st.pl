% this file is a draft.
:- module(st, [state/1]).

:- use_module(attr).

state1(State):-
    State = [I, M, A, S],
    member(I, [1,0]), 
    member(M, [1,0]), 
    member(A, [1,0]),
    member(S, [1,0]). 

state(State):-
    stateaux(State, 1),
    pick(Slot, State, _),
    val(Slot).

stateaux(State, N):-
    attributesl(N),
    length(State, N).


pick(H, [H|T], T).
