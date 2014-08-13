:- module(val, [eval/3]).

values([life, freedom, happiness]).

values(carla, [life, freedom]).
values(hal, [life, freedom]).

better(0, 2).
better(1, 2).
better(0, 1).

worse(2, 1).
worse(2, 0).
worse(1, 0).

promote(a, life).
promote(i, life).
promote(m, freedom).

demote(a, life).
demote(i, life).
demote(m, freedom).

equal(Val1, Val2):- Val1 = Val2.

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

eval(Qi, Qf, List):-
    setof(Eval,(promotion(Qi, Qf, Eval); demotion(Qi, Qf, Eval)),  List).
