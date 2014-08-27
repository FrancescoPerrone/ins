:-module(trans, [trans/5]).

%% init(-I:list)
%
%  Set of all initial possible initial states.
%  
%  @arg I initial state
%  @see state/1
%
initial_state(I):-
    % I = [0,_,1,1,_,1],
    state(I).

trans(Init, Ac, L, Next, 1):-
    initial_state(Init),
    perform(Init, Next, Ac),
    eval(Init, Next, L).
trans(Init, Ac, _, Next, N):-
    Step is N - 1,
    N > 0,
    initial_state(Init),
    perform(Init, X, Ac),
    initial_state(X),
    trans(X, Ac, _, Next, Step).

trans_label(Init, L, A-N, B-P):-
    initial_state(Init),
    perform(Init, N, A),
    perform(Init, P, B),
    not(N == P),
    eval(N, P, L).

jtrans(Init, Jac, L, Next):-
    performj(Init, Next, Jac),
    eval(Init, Next, L).

/*
findAcs(Acs, In):-
    bagof(Ac, Next^(perform(In, Next, Ac)), Acs).
*/
