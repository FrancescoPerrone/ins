:- module(args, [arg/2, argument/3, attacks/2]).

%% argument(+Ag, -Acts, -Val)
%
%  Constructs arguments from an agent's perspective.
%  An argument is a 2-step action sequence that promotes Val for Ag
%  from some initial state.
%
%  Hal reasons over individual action sequences (trans/4).
%  Carla reasons over joint action sequences (transj/4), reflecting
%  that her outcomes depend on coordinated action with Hal.
%
argument(hal, Acts, Val):-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     trans(Init, Acts, Next, 2),
                     better(hal, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

argument(carla, Acts, Val):-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     transj(Init, Acts, Next, 2),
                     better(carla, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

%% arg(-Acts, -Val)
%
%  Backwards-compatible wrapper: Hal's arguments.
%
arg(Acts, Val) :- argument(hal, Acts, Val).


%% attacks(+A, +B)
%
%  Argument A attacks argument B when they advocate different action
%  sequences.  The attack relation is symmetric and agent-agnostic:
%  any two arguments with distinct action sequences mutually attack.
%
attacks(arg(Acts, V1), arg(ActsX, V2)):-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.
