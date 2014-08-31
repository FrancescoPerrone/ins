:- module(value, [value/1, sub/2, affects/2, better/4, worse/4, eval/4]).

% all values
value(lifeH).
value(lifeC).
value(freedomH).
value(freedomC).

% means that an agent subscribes to a set of values
sub([lifeH, lifeC, freedomH, freedomC], hal).

% attributes([ih,mh,ah,ic,mc,ac]) @see state.pl
affects(mh, freedomH).
affects(mc, freedomC).
affects(ih, lifeH).
affects(ic, lifeC).
affects(ah, lifeH).
affects(ac, lifeC).


%           Evaluation function


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

neut(Ag, S1, S2, Val):-
    value(Val),
    sub(SetV, Ag),
    member(Val, SetV),
    affects(At, Val),
    attribute(At, S1, Val1),
    attribute(At, S2, Val2),
    Val1 = Val2.

eval(Ag, S1, S2, Eval):-
    setof(Val,
	  (promotes(Ag, S1, S2, Val)
	   ; demotes(Ag, S1, S2, Val)),
	  Eval),
    true.


%           Formats evaluation function

 
promotes(Ag, S1, S2, +Val):-
    agent(Ag),
    better(Ag, S1, S2, Val).

demotes(Ag, S1, S2, -Val):-
    agent(Ag),
    worse(hal, S1, S2, Val).

neutral(Ag, S1, S2, @Val):-
    agent(Ag),
    neut(Ag, S1, S2, Val).

