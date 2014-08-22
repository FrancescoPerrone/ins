:- module(val, [better/3, eval/3, promote/3, demote/3]).

/** <module> Values and evaluation function

This file provides defintion for Hal's set of values
and also provides an evalution function which defines
the status of a value abscribed by Hal to the
transition between two states.

@author Francesco Perrone
@license GNU

@see trans.pl

*/

%% subsc(-Values:list, ?Agent) is det
%  
%  Agent's set of values.
%  It means that 'Agent' subscribes these 'Values'.
%
%  @arg Values a set of social attitudes/interests
%  @arg Agent agent's name.

subsc([lifeH, lifeC, freedomH, freedomC], hal).

%% better(-A:state, -B:state, ?Val) is det
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
better([_,0,_,_,_,_], [_,1,_,_,_,_], freedomH).
better([_,_,0,_,_,_], [_,_,1,_,_,_], lifeH).
better([_,_,_,0,_,_], [_,_,_,1,_,_], lifeC).
better([_,_,_,_,0,_], [_,_,_,_,1,_], freedomC).
better([_,_,_,_,_,0], [_,_,_,_,_,1], lifeC).

%% worse(-A:state, -B:state, ?Val) is det
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
worse([_,1,_,_,_,_], [_,0,_,_,_,_], freedomH).
worse([_,_,1,_,_,_], [_,_,0,_,_,_], lifeH).
worse([_,_,_,1,_,_], [_,_,_,0,_,_], lifeC).
worse([_,_,_,_,1,_], [_,_,_,_,0,_], freedomC).
worse([_,_,_,_,_,1], [_,_,_,_,_,0], lifeC).


%% promote(?Ini, ?Fin, ?V)
%
%  Promotion function
%  Defines what it takes for a value to be
%  promoted in a transition.
%
%  @arg Ini the initial state
%  @arg Fin the new state
%  @arg V indicates that V is promoted

promote(Ini, Fin, +V):-
    subsc(Set, hal),
    member(V, Set),
    better(Ini, Fin, V).

%% demote(?Ini:state, ?Fin:state, ?V:value)
%
%  Demotion function
%  Defines what it takes for a value to be
%  demoted in a transition.
%
%  @arg Ini the initial state
%  @arg Fin the new state
%  @arg V indicates that V is promoted

demote(Ini, Fin, -V):-
    subsc(Set, hal),
    member(V, Set),
    worse(Ini, Fin, V).

%% eval(?Ini:state, ?Fin:state, -L:list)
%
%  Evaluation set.
%  Create a set containing an evaluation
%  of what has been promoted/demoted
%  in a transition, under Hal's point
%  of view.
%
%  @arg Ini an initial state
%  @arg Fin a new state
%  @arg L a list of value's status
%  @see promote/3 a status
%  @see demote/3  a status
%

eval(Ini, Fin, L):-
    setof(V, 
	  (promote(Ini, Fin, V); demote(Ini, Fin, V)),
	  L).
