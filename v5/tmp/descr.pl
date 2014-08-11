% file: descr.pl
% information on the insulin problem
% this file should be loaded from state or attributes..
:- module(descr, [insulin/2, alive/2, money/2, shops/2]).

% properties can take values
i(State, Val):-
    state(State),
    State = [I, _, _, _],
    I = Val.

a(State, Val):-
    state(State),
    State  = [_, _, A, _],
    A = Val.

m(State, Val):-
    state(State),
    State  = [_, M, _, _],
    M = Val.

s(State, Val):-
    state(State),
    State  = [_, _, _, S],
    S = Val.
