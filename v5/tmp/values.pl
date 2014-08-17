% file: val.pl
:- module(values, [eval/4]).

% ℒ (the language)
% ------------------

values(carla, [life, freedom]).
values(hal, [life, freedom]).

% non transitive
better(0, 1).
% non transitive
worse(1, 0).

affects(i, freedom).
affects(m, freedom).
affects(a, life).


eval(Ag, Qi, Qf, List):-
    setof(Eval-Ag,(promotion(Ag, Qi, Qf, Eval); demotion(Ag, Qi, Qf, Eval)),  List), !.
% The following prevents failure under non-specified/wrong evaluations.
% Needed to make the transition system more robust.
eval(Ag, _, _, [neutral-Ag]):-
    agent(Ag).

promotion(Ag, Qi, Qf, +Val):-
    state(Qi),  state(Qf),
    agent(Ag),
    values(Ag, Vals),
    member(Val, Vals),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    better(Vi, Vf).

demotion(Ag, Qi, Qf, -Val):-
    state(Qi),  state(Qf),
    agent(Ag),
    values(Ag, Vals),
    member(Val, Vals),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    worse(Vi, Vf).

% neutrality is not considered for the time being.

neutral(Qi, Qf, Val-Ag):-
    state(Qi),  state(Qf),
    agent(Ag),
    values(Ag, Vals),
    member(Val, Vals),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    equal(Vi, Vf).

equal(Val1, Val2):- Val1 = Val2.

/*
promotion(Qi, Qf, +Val):-
    state(Qi),  state(Qf),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    better(Vi, Vf).

demotion(Qi, Qf, -Val):-
    state(Qi),  state(Qf),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    worse(Vi, Vf).
*/
