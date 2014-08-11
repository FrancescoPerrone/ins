% file: trans.pl
:- module(trans, [transient/3]).
% τ (partial transition function)

% 1. joint action j
% 2. precondition for j
% 3. resulting state

transient(Init, buy, Next).

transient(Init, compensate, Next).

transient(Init, doNothing, Next).

transient(Init, lose, Next):-
    precondition(lose, Init),
    state(Next),
    attribute(i, Next, 0).


transient(Init, take, Next):-
    precondition(take, Init),
    state(Next),
    attribute(i, Next, 1).
