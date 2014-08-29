:- module(trans, [better/4, trans/4, initial_state/1, arg/2]).

value(lifeH).
value(lifeC).
value(freedomH).
value(freedomC).


sub([lifeH, lifeC, freedomH, freedomC], hal).

% attributes([ih,mh,ah,ic,mc,ac]) @see state.pl

affects(mh, freedomH).
affects(mc, freedomC).
affects(ih, lifeH).
affects(ic, lifeC).
affects(ah, lifeH).
affects(ac, lifeC).

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

arg(ActsX, Val):-
    initial_state(Init),
    trans(Init, ActsX, NextX, 2),
    trans(Init, Acts, Next, 2),
    Acts \= ActsX,
    better(hal, Next, NextX, Val).

attacks(arg(Acts, V1), arg(ActsX, V2)):-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.


better(Ag, StateA, StateB, Val):-
    value(Val),
    sub(SetV, Ag),
    member(Val, SetV),
    affects(At, Val),
    attribute(At, StateA, 0),
    attribute(At, StateB, 1).
    

worse(Ag, StateA, StateB, Val):-
    value(Val),
    sub(SetV, Ag),
    member(Val, SetV),
    affects(At, Val),
    attribute(At, StateA, 1),
    attribute(At, StateB, 0).
