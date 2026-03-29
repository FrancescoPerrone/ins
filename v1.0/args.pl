:- module(args, [arg/2, attacks/2]).

arg(ActsX, Val):-
    setof(ActsX-Val,
          Init^NextX^(initial_state(Init),
                      trans(Init, ActsX, NextX, 2),
                      better(hal, Init, NextX, Val)),
          Pairs),
    member(ActsX-Val, Pairs).

attacks(arg(Acts, V1), arg(ActsX, V2)):-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.
