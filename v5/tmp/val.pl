% file: val.pl
:- module(val, [eval/3]).

% ℒ (the language)
% ------------------

values([life, freedom, happiness]).

values(carla, [life, freedom]).
values(hal, [life, freedom]).

% non transitive
better(0, 1).
%better(1, 2).
%better(0, 2).
% non transitive
%worse(2, 1).
worse(1, 0).
%worse(2, 0).

affects(i, freedom).
affects(m, freedom).
affects(a, life).

% Predicates
% ------------------

eval(Qi, Qf, List):-
    setof(Eval,(promotion(Qi, Qf, Eval); demotion(Qi, Qf, Eval)),  List), !.
% The following prevents failure under non-specified/wrong evaluations.
% Needed to make robust the transition system.
eval(_, _, [none]).

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

% neutrality is not considered for the time being.

neutral(Qi, Qf, Val):-
    state(Qi),  state(Qf),
    affects(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    equal(Vi, Vf).

equal(Val1, Val2):- Val1 = Val2.
