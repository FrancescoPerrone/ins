% file: descr.pl
% information on the insulin problem
:- module(descr, [insulin/2, alive/2, money/2, shops/2]).

% properties can take values
insulin(State, Val):-
    state(State),
    State = [I, _, _, _],
    I = Val.

alive(State, Val):-
    state(State),
    State  = [_, _, A, _],
    A = Val.

money(State, Val):-
    state(State),
    State  = [_, M, _, _],
    M = Val.

shops(State, Val):-
    state(State),
    State  = [_, _, _, S],
    S = Val.
