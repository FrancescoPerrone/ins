:- module(trans, [trans/4, initial_state/1]).

initial_state(Init):-
    Init = [0,_,1,1,_,1],
    state(Init).

trans(Init, [Act], Next, 1):-
    perform(Init, Next, Act).
trans(Init, [Act|Rest], Next, N):-
    N > 1,
    Step is N - 1,
    perform(Init, X, Act),
    trans(X, Rest, Next, Step).
