:- module(value, [value/1, sub/2, affects/2, better/4, worse/4, eval/4]).

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


eval(Ag, S1, S2, Eval):-
    setof(Val,(better(Ag, S1, S2, Val)
	       ;worse(Ag, S1, S2, Val)), Eval).
	     
