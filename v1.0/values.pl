:- module(value, [value/1, sub/2, affects/2, better/4, worse/4, eval/4]).

% all values
value(lifeH).
value(lifeC).
value(freedomH).
value(freedomC).

% means that an agent subscribes to a set of values
sub([lifeH, lifeC, freedomH, freedomC], hal).
sub([lifeC, freedomC], carla).

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

% eval/4 was originally written to collect only promoted (+Val) and demoted
% (-Val) values, intentionally omitting neutral ones (@(Val)).  The
% rationale was that only promoted/demoted values participate in argument
% construction (better/4, worse/4) and in the Dung attack relation, so
% neutral values add no information to the argumentation layer.
%
% They are included here for completeness: a full state evaluation should
% account for every subscribed value, not only the ones that changed.
% The @(Val) tag keeps them visually distinct from promotions/demotions so
% callers that only care about changes can still filter them out.
eval(Ag, S1, S2, Eval):-
    setof(Val,
	  (promotes(Ag, S1, S2, Val)
	   ; demotes(Ag, S1, S2, Val)
	   ; neutral(Ag, S1, S2, Val)),
	  Eval),
    true.


%           Formats evaluation function

 
promotes(Ag, S1, S2, +Val):-
    agent(Ag),
    better(Ag, S1, S2, Val).

demotes(Ag, S1, S2, -Val):-
    agent(Ag),
    worse(Ag, S1, S2, Val).

neutral(Ag, S1, S2, @(Val)):-
    agent(Ag),
    neut(Ag, S1, S2, Val).

