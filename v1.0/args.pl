:- module(args, [arg/2, attacks/2]).

arg(ActsX, Val):-
    initial_state(Init),
    trans(Init, ActsX, NextX, 2),
    not(not((trans(Init, Acts, Next, 2),
    Acts \= ActsX,
    better(hal, Next, NextX, Val)))).

attacks(arg(Acts, V1), arg(ActsX, V2)):-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.
