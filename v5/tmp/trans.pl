:- module(trans, [old_transition/4]).
% file: trans.pl
%
% This file describes patterns of transitions.
% The transition described below is one that
% consider 'one agent acting'.
% No joint actions are involved.


% τ (partial transition function)


old_transition(Init, Action, Label, Next):-
    perform(Init, Next, Action),
    eval(Init, Next, Label).

% demotes freedom
% promote life
perform(Init, Next, buy):-
    precondition(buy, Init),
    Init = [_, M, A],
    state(Next),
    attribute(i, Next, 1),
    attribute(m, Next, Mn), Mn is (M - 1),
    attribute(a, Next, A).

% demotes freedom
perform(Init, Next, compensate):-
    precondition(compensate, Init),
    Init = [I, M, A],
    state(Next),
    attribute(i, Next, I),
    attribute(m, Next, Mn), Mn is (M - 1),
    attribute(a, Next, A).

% demotes life if insulin is 0
perform(Init, Next, doNothing):-
    precondition(doNothing, Init),
    Init = [I, M, A],
    Next = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).

% demotes life
perform(Init, Next, lose):-
    precondition(lose, Init),
    Init = [I, M, A],
    state(Next),
    attribute(i, Next, In), In is (I - 1),
    attribute(m, Next, M),
    attribute(m, Next, A).

% promote freedom
perform(Init, Next, take):-
    precondition(take, Init),
    Init = [I, M, A],
    state(Next),
    attribute(i, Next, In), In is (I + 1),
    attribute(m, Next, M),
    attribute(a, Next, A).
