% file: restr.pl
:- module(restr, [restriction/1]).

% define a subset of possible worlds from the set of all
% possible states.

% this file requires q.pl and descr.pl

restriction(State):-
    state(State),
    (insulin(State, 1) -> alive(State, 1));
    (insulin(State, 0) -> alive(State, A), member(A, [1,0])).
