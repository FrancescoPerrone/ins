:-module(trs, [trans/4]).

/** <module> Transitiona System

@author Francesco Perrone
@license GNU

*/

%% init(-I:list)
%
%  Set of all initial possible initial states.
%  
%  @arg I initial state
%  @see state/1
%
initial_state(I):-
    I = [0,_,1,1,_,1],
    state(I).

trans(Init, [Ac], Next, 1):-
    perform(Init, Next, Ac).
trans(Init, [Ac|Rest], Next, N):-
    N > 1,
    Step is N - 1,
    perform(Init, X, Ac),
    trans(X, Rest, Next, Step).

label(Init, Next, lifeH):-
    trans(Init, Ac, Next, 1),
    trans(Init, Acx, Nextx, 1),
    Ac \= Acx,
    better(Next, Nextx, lifeH).

better(Init, Next, V):-
    state(Init),
    state(Next),
    value(V)
    attribute(V, Init, 0),
    attribute(V, Next, 1).
