:- module(trans, [trans/4, transj/4, initial_state/1]).

:- use_module(jactions).

% original: Hal lacks insulin, Carla has it
initial_state(Init):-
    Init = [0,_,1,1,_,1],
    state(Init).

% Carla lacks insulin; Hal has insulin and money and can give it (for lifeC)
initial_state(Init):-
    Init = [1,1,1,0,_,1],
    state(Init).

% Carla lacks money; Hal has everything and can compensate (for freedomC)
initial_state(Init):-
    Init = [1,1,1,1,0,1],
    state(Init).

trans(Init, [Act], Next, 1):-
    perform(Init, Next, Act).
trans(Init, [Act|Rest], Next, N):-
    N > 1,
    Step is N - 1,
    perform(Init, X, Act),
    trans(X, Rest, Next, Step).

transj(Init, [Jac], Next, 1):-
    performj(Init, Next, Jac).
transj(Init, [Jac|Rest], Next, N):-
    N > 1,
    Step is N - 1,
    performj(Init, X, Jac),
    transj(X, Rest, Next, Step).
