% file: restriction.pl
:- module(restriction, [restriction/1]).

% define a subset of possible worlds from the set of all
% possible states. this file should be loaded separetely from
% aats.pl

% As per the description given in Bench-Capon's (2003),
% the attribute 'i' cannot be 1 and 'a' be 0 or 1 

restriction(State):-
    state(State),
    (attribute(i, State, 1) -> attribute(a, State, 1));
    (attribute(i, State, 0) -> attribute(a, State, A), member(A, [1,0])).


% The following applies for domains with values other then 1 and 0

/*
restriction(State):-
    states(Set),
    member(State, Set),
    (attribute(i, State, 1) -> attribute(a, State, 2));
    (attribute(i, State, 0) -> attribute(a, State, A), member(A, [1,0])).
*/
