% file: q.pl
:- module(q, [state/1, states/1]).

% a state is a vector of attributes

state(State):-
    State = [I, M, A, S],
    attribute(I),
    attribute(M),
    attribute(A),
    attribute(S).

attribute(A):-
    member(A, [1,0]).


% Q (set of states)

states(Set):-
    findall(S, state(S), Set).
