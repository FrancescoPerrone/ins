action(State-Ag, lose):-
    agent(Ag),
    insulin(State, 1),
    alive(State, A),
    member(A, [1, 2]). % if Ag has insulin, alive must be 2

action(State-Ag, compensate):-
    agent(Ag),
    insulin(State, 1),
    money(State, M),
    member(M, [1,2]),
    alive(State, A),
    member(A, [1,2]). % if Ag has insulin, alive must be 2

action(State-Ag, take):-
    agent(Ag),
    insulin(State, 0),
    alive(State, A),
    member(A, [1,2]). % if Ag has insulin, alive must be 2

action(State-Ag, buy):-
    agent(Ag),
    insulin(State, 0),
    money(State, M),
    member(M, [1,2]),
    alive(State, A),
    member(A, [1,2]), % if Ag has insulin, alive must be 2
    world(State, 1).

action(State-Ag, doNothing):-
    agent(Ag),
    state(State).

% SYSTEM TRANSITION FUNCTION
% Defines the next-state resulting by performing an action

perform(Init-Ag, Fin, lose):-
    action(Init-Ag, lose),
    Init = [I, M, A, S],
    member(A, [1,2]), % if Ag has insulin, alive must be 2
    Fin = [If, Mf, Af, Sf],
    If is (I - 1),
    Mf = M,
    member(Af, [1,2]), % if Ag hasn't insulin, alive must be 1
    Sf = S.

perform(Init-Ag, Fin, compensate):-
    action(Init-Ag, compensate),
    Init = [I, M, A, T],
    Fin = [If, Mf, Af, Tf],
    If = I,
    Mf is (M - 1),
    Af = A,
    Tf = T.

perform(Init-Ag, Fin, buy):-
    action(Init-Ag, buy),
    Init = [I, M, A, S],
    member(A, [1,2]),  % if Ag has insulin, alive must be 2
    Fin = [If, Mf, Af, Sf],
    If is (I + 1),
    Mf is (M - 1),
    member(Af, [1,2]), % if Ag hasn't insulin, alive must be 1
    Sf = S. % a transition for S is left unconsidered

perform(Init-Ag, Fin, take):-
    action(Init-Ag, take),
    Init = [I, M, A, S],
    member(A, [1,2]),
    Fin = [If, Mf, Af, Sf],
    If is (I + 1),
    Mf = M,
    member(Af, [1, 2]),
    Sf = S.

perform(Init-Ag, Fin, doNothing):-
    action(Init-Ag, doNothing),
    Init = [I, M, A, T],
    Fin = [I, M, Af, T], 
    (
	(A = 1, I = 0) *-> Af = 0;
	Af = A
    ).
