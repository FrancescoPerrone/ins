:- module(trans, [transition/3]).
% file: trans.pl
% --------------------------------------------
% This file describes patterns of transitions.
% The transition described below is one that
% consider 'one agent acting'.
% No joint actions are involved.


% τ (partial transition function)


transition(Init, Action, Next):-
    perform(Init, Next, Action).

% demotes freedom
% promote life
perform(Init, Next, buy):-
    precondition(buy, Init),
    Init = [_, M, A, S],
    state(Next),
    attribute(i, Next, 1),
    attribute(m, Next, Mn), Mn is (M - 1),
    attribute(a, Next, A),
    attribute(s, Next, S).

% demotes freedom
perform(Init, Next, compensate):-
    precondition(compensate, Init),
    Init = [I, M, A, S],
    state(Next),
    attribute(i, Next, I),
    attribute(m, Next, Mn), Mn is (M - 1),
    attribute(a, Next, A),
    attribute(s, Next, S).

% demotes life if insulin is 0
perform(Init, Next, doNothing):-
    precondition(doNothing, Init),
    Init = [I, M, A, T],
    Next = [I, M, An, T], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).

% demotes life
perform(Init, Next, lose):-
    precondition(lose, Init),
    Init = [I, M, A, S],
    state(Next),
    attribute(i, Next, In), In is (I - 1),
    attribute(m, Next, M),
    attribute(m, Next, A),
    attribute(a, Next, S).

% promote freedom
perform(Init, Next, take):-
    precondition(take, Init),
    Init = [I, M, A, S],
    state(Next),
    attribute(i, Next, In), In is (I + 1),
    attribute(m, Next, M),
    attribute(a, Next, A),
    attribute(s, Next, S).
