% file: val.pl
:- module(val, [eval/3]).

% ℒ (the language)
% ------------------

values([life, freedom, happiness]).

values(carla, [life, freedom]).
values(hal, [life, freedom]).

better(0, 1).
better(1, 2).
better(0, 2).

% notice: 
% according to Bench-Capon's view, life is demoted onlu upon agent's death
worse(2, 1).
worse(1, 0).
worse(2, 0).

% 'promote' and 'demote' could be unified into affect(Attribute, Value).
% However, 'affect', 'promote', and 'demote' might all
% have a different meaning which cannot converg into one fact.

% according to Bench-Capon's view, insulin does not affect any of the value listed
% promote(i, freedom).
promote(m, freedom).
promote(a, life).
% demote(i, freedom).
demote(m, freedom).
demote(a, life).


% Predicates
% ------------------

promotion(Qi, Qf, +Val):-
    state(Qi),  state(Qf),
    promote(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    better(Vi, Vf).

demotion(Qi, Qf, -Val):-
    state(Qi),  state(Qf),
    demote(At, Val),
    attribute(At, Qi, Vi), attribute(At, Qf, Vf),
    worse(Vi, Vf).

% the following is for a neutral(Qi, Qf, Val) predicate.
% For the time being I will not consider neutrality in the
% transition.
equal(Val1, Val2):- Val1 = Val2.



eval(Qi, Qf, List):-
    setof(Eval,(promotion(Qi, Qf, Eval); demotion(Qi, Qf, Eval)),  List).
