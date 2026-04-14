:- module(args, [arg/2, argument/3, argument/4, attacks/2]).
:- use_module(library(pldoc)).

/** <module> Argument construction and attack relation.

Implements AS1 (positive) and AS2 (negative) argument schemes from
Atkinson & Bench-Capon (2006).

  AS1 — In circumstances R, perform A, leading to S, realising G,
         promoting value V.

  AS2 — In circumstances R, perform A, to avoid S, which would
         demote value V.

argument/4 is the primary predicate; argument/3 and arg/2 are
backward-compatible wrappers retained so attacks/2, extensions.pl,
and vaf.pl need no changes.

@author Francesco Perrone
@license GPL
*/


%% argument(+Ag, -Acts, -Val, -Scheme) is nondet
%
%  Constructs arguments for agent Ag.
%  Scheme is as1 (promotes Val) or as2 (protects Val from demotion).
%
%  Hal reasons over individual action sequences (trans/4).
%  Carla reasons over joint action sequences (transj/4).
%
%  Note: AS1 and AS2 are mutually exclusive for a given (Init, Val) pair,
%  but not at the (Acts, Val) level: the same action sequence may appear
%  under both schemes if it improves a value from one initial state while
%  protecting it from a different initial state. The scheme tag records
%  how the argument was constructed, not a clean partition.
%
%  @arg Ag    Agent: hal or carla
%  @arg Acts  2-step action sequence
%  @arg Val   Value promoted or protected
%  @arg Scheme as1 or as2

% --- Hal AS1 ---
argument(hal, Acts, Val, as1) :-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     trans(Init, Acts, Next, 2),
                     better(hal, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

% --- Hal AS2 ---
argument(hal, Acts, Val, as2) :-
    value(Val),
    setof(Acts,
          Init^Next^Alt^AltNext^(
              initial_state(Init),
              trans(Init, Acts, Next, 2),
              \+ worse(hal, Init, Next, Val),
              trans(Init, Alt, AltNext, 2),
              worse(hal, Init, AltNext, Val)
          ),
          ActsList),
    member(Acts, ActsList).

% --- Carla AS1 ---
argument(carla, Acts, Val, as1) :-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     transj(Init, Acts, Next, 2),
                     better(carla, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

% --- Carla AS2 ---
argument(carla, Acts, Val, as2) :-
    value(Val),
    setof(Acts,
          Init^Next^Alt^AltNext^(
              initial_state(Init),
              transj(Init, Acts, Next, 2),
              \+ worse(carla, Init, Next, Val),
              transj(Init, Alt, AltNext, 2),
              worse(carla, Init, AltNext, Val)
          ),
          ActsList),
    member(Acts, ActsList).


%% argument(+Ag, -Acts, -Val) is nondet
%
%  Backward-compatible wrapper: strips the scheme tag.
%  Retained so dbg.pl and other callers need minimal changes.
%
argument(Ag, Acts, Val) :- argument(Ag, Acts, Val, _).


%% arg(-Acts, -Val) is nondet
%
%  AS1-only wrapper used by attacks/2, extensions.pl, and vaf.pl.
%  Restricted to AS1 to keep the argument set tractable for the
%  brute-force powerset computation in extensions.pl (O(2^n)).
%  AS2 arguments are exposed via argument/4 in the API but do not
%  participate in Dung extensions or the attack relation.
%
arg(Acts, Val) :- argument(hal, Acts, Val, as1).


%% attacks(+A, +B) is nondet
%
%  Argument A attacks argument B when they advocate different action
%  sequences. The attack relation is symmetric and scheme-agnostic.
%
attacks(arg(Acts, V1), arg(ActsX, V2)) :-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.
