:- module(val, [eval/3, promote/3, demote/3, neutral/3]).
:- use_module(library(pldoc)).

/** <module> Values and evaluation functions

This file defines Hal's set of values
and provides predicates for evaluating the status of a
value in the agent's set, after a transition.

e.g.

==
?- eval([0,1,1,1,1,1],[1,0,1,1,1,1], E).
E = [+lifeH, -freedomH].
true.

?- eval([0,0,1,1,1,1],[1,0,1,0,1,1], E).
E = [+lifeH, -lifeC].
true.
==

@author Francesco Perrone
@license GNU

@see trans.pl

*/

%% subsc(-Values:list, -Agent) is det
%  
%  Agent's set of values.
%  It means that 'Agent' subscribes these 'Values'.
%
%  @arg Values a set of social attitudes/interests
%  @arg Agent agent's name.
%
subsc([lifeH, lifeC, freedomH, freedomC], hal).

%% better(?A:state, ?B:state, ?Val) is semidet
%  Defines the value's status 'better'
%  
%  It means that in state state 'B' the status
%  of 'Val' is 'better' under Hal's point of
%  view.
%
%  @arg A a state
%  @arg B a state
%  @arg Val a value
%
better([0,_,_,_,_,_], [1,_,_,_,_,_], lifeH).
better([_,_,0,_,_,_], [_,_,1,_,_,_], lifeH).
better([_,_,_,0,_,_], [_,_,_,1,_,_], lifeC).
better([_,_,_,_,_,0], [_,_,_,_,_,1], lifeC).
better([_,0,_,_,_,_], [_,1,_,_,_,_], freedomH).
better([_,_,_,_,0,_], [_,_,_,_,1,_], freedomC).

%% better(?A:state, ?B:state, ?Val) is semidet
%  Defines the value's status 'worse'
%  
%  It means that in state state 'B' the status
%  of 'Val' is 'worse' under Hal's point of
%  view.
%
%  @arg A a state
%  @arg B a state
%  @arg Val a value
%
worse([1,_,_,_,_,_], [0,_,_,_,_,_], lifeH).
worse([_,_,1,_,_,_], [_,_,0,_,_,_], lifeH).
worse([_,_,_,1,_,_], [_,_,_,0,_,_], lifeC).
worse([_,_,_,_,_,1], [_,_,_,_,_,0], lifeC).
worse([_,1,_,_,_,_], [_,0,_,_,_,_], freedomH).
worse([_,_,_,_,1,_], [_,_,_,_,0,_], freedomC).

same([I,_,_,_,_,_], [I,_,_,_,_,_], lifeH).
same([_,_,A,_,_,_], [_,_,A,_,_,_], lifeH).
same([_,_,_,I,_,_], [_,_,_,I,_,_], lifeC).
same([_,_,_,_,_,A], [_,_,_,_,_,A], lifeC).
same([_,M,_,_,_,_], [_,M,_,_,_,_], freedomH).
same([_,_,_,_,M,_], [_,_,_,_,M,_], freedomC).

%% promote(?Ini, ?Fin, ?V)
%
%  Promotion definition
%  Defines what it takes for a value to be
%  promoted in a transition.
%
%  @arg Ini the initial state
%  @arg Fin the new state
%  @arg V indicates that V is promoted
%
promote(Ini, Fin, +V):-
    subsc(Vset, hal),
    member(V, Vset),
    state(Ini), state(Fin),
    better(Ini, Fin, V).

%% demote(?Ini:state, ?Fin:state, ?V:value)
%
%  Demotion function
%  Defines what it takes for a value to be
%  demoted in a transition.
%
%  @arg Ini the initial state
%  @arg Fin the new state
%  @arg V indicates that V is demoted
%
demote(Ini, Fin, -V):-
    subsc(Vset, hal),
    member(V, Vset),
    state(Ini), state(Fin),
    worse(Ini, Fin, V).


neutral(Ini, Fin, n-V):-
    subsc(Vset, hal),
    member(V, Vset),
    state(Ini), state(Fin),
    same(Ini, Fin, V).

%% eval(?Ini:state, ?Fin:state, -Eval:list)
%
%  Evaluation function.
%  Create a set containing an evaluation
%  of what has been promoted/demoted
%  in a transition, under Hal's point
%  of view.
%
%  @arg Ini an initial state
%  @arg Fin a new state
%  @arg Eval a list of value's status
%
%  @see promote/3 a status
%  @see demote/3  a status
%
eval(Ini, Fin, Eval):-
    setof(V, 
	  (promote(Ini, Fin, V); demote(Ini, Fin, V)/*; neutral(Ini, Fin, V)*/),
	  Eval), !.
eval(_, _, ['n/a']).
