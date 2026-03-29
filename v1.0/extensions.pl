:- module(extensions, [
    all_arguments/1,
    conflict_free/1,
    defends/2,
    admissible/1,
    preferred_extension/1,
    grounded_extension/1,
    stable_extension/1
]).

:- use_module(args).

/** <module> Dung-style abstract argumentation semantics.

Implements the core Dung (1995) semantics over the argument set
produced by arg/2 and the attack relation produced by attacks/2.

Semantics provided:
  - conflict_free/1   — no internal conflicts
  - admissible/1      — conflict-free and self-defending
  - preferred_extension/1 — maximal admissible sets
  - grounded_extension/1  — least fixed point of the characteristic function
  - stable_extension/1    — conflict-free and attacks all outside arguments

@see args.pl
@author Francesco Perrone
@license GPL
*/


%% all_arguments(-Args:list) is det
%
%  Collect all arguments from arg/2 into a sorted list of arg/2 terms.
%
all_arguments(Args) :-
    setof(arg(Acts, Val), arg(Acts, Val), Args).


%% conflict_free(+Set:list) is semidet
%
%  Set is conflict-free if no member attacks any other member.
%
conflict_free(Set) :-
    \+ (member(A, Set), member(B, Set), attacks(A, B)).


%% defends(+Set:list, +A:term) is semidet
%
%  Set defends A if every argument that attacks A is itself
%  attacked by some member of Set.
%
defends(Set, A) :-
    \+ (attacks(B, A), \+ (member(C, Set), attacks(C, B))).


%% admissible(+Set:list) is semidet
%
%  Set is admissible if it is conflict-free and defends all its members.
%
admissible(Set) :-
    conflict_free(Set),
    forall(member(A, Set), defends(Set, A)).


%% preferred_extension(-Ext:list) is nondet
%
%  Ext is a preferred extension: a maximal admissible set.
%  Enumerates all preferred extensions on backtracking.
%
preferred_extension(Ext) :-
    all_arguments(AllArgs),
    powerset(AllArgs, Ext),
    admissible(Ext),
    \+ (member(X, AllArgs),
        \+ member(X, Ext),
        admissible([X|Ext])).


%% grounded_extension(-Ext:list) is det
%
%  Ext is the grounded extension: the least fixed point of the
%  characteristic function F_AF(S) = { a | S defends a }.
%  Computed iteratively from the empty set.
%
grounded_extension(Ext) :-
    grounded_fp([], Ext).

grounded_fp(S, Ext) :-
    all_arguments(AllArgs),
    findall(A, (member(A, AllArgs), defends(S, A)), Next0),
    sort(Next0, Next),
    sort(S, SS),
    (SS = Next -> Ext = Next ; grounded_fp(Next, Ext)).


%% stable_extension(-Ext:list) is nondet
%
%  Ext is a stable extension: conflict-free and attacks every
%  argument not in Ext.
%  Enumerates all stable extensions on backtracking.
%
stable_extension(Ext) :-
    all_arguments(AllArgs),
    powerset(AllArgs, Ext),
    conflict_free(Ext),
    forall(member(A, AllArgs),
           (member(A, Ext) ; (member(B, Ext), attacks(B, A)))).


% --- Helpers ---

%% powerset(+List:list, -Sub:list) is nondet
%
%  Sub is a subset of List. Enumerates all subsets on backtracking.
%
powerset([], []).
powerset([_|T], Sub)    :- powerset(T, Sub).
powerset([H|T], [H|Sub]):- powerset(T, Sub).


%% is_subset(+Sub:list, +Sup:list) is semidet
%
%  Every element of Sub is a member of Sup.
%
is_subset(Sub, Sup) :-
    forall(member(X, Sub), member(X, Sup)).
