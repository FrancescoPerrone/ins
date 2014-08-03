state([I, M, A, W]):-
    member(I, [1, 0]),
    member(M, [2, 1, 0]),
    member(A, [2, 1, 0]),
    member(W, [1, 0]).

insulin(State, Val):-
    State = [I, _, _, _],
    I = Val.

alive(State, Val):-
    State  = [_, _, A, _],
    A = Val.

money(State, Val):-
    State  = [_, M, _, _],
    M = Val.

shop(State, Val):-
    State  = [_, _, _, S],
    S = Val.

restriction(State):-
    state(State),
    (insulin(State, 1) -> alive(State, 2));
    (insulin(State, 0) -> alive(State, I), member(I, [1,0])).


% π (interpretation function)
interpret(Intr, State-Ag):-
    agent(Ag),
    findall(I-Ag, interpretation(State, I), Intr).

interpretation(State, insulin):-
    insulin(State, 1).

interpretation(State, money):-
    money(State, M),
    member(M, [1,2]).

interpretation(State, alive):-
    alive(State, A),
    member(A, [1,2]).

interpretation(State, open):-
    shop(State, 1).
