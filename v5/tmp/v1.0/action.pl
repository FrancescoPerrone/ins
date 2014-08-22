:- module(act, [precond/2, perform/3]).
:- use_module(library(pldoc)).
:- doc_save(., [recursive(true)]).

/** <module> Action precondition and partial transition function

This file provides definitions for actions, action's precondition
and partial transition function.

@see precond/2 the precondition function
@see perform/3 the partial transition function

e.g.
==
?- precon(buy, State).
State = [0, 1, 1, _G2090, _G2093, _G2096].

?- perfor(Ini, Fin, buy).
Ini = [0, 1, 1, _G2104, _G2107, _G2110],
Fin = [1, 0, 1, _G2104, _G2107, _G2110].
true.
==


@author Francesco Perrone
@license GNU
*/

%% precond(?Action, ?State:state) is semidet
%
%  Action's precondition function.
%  Meaning that 'Action' can be performed from 'State'.
%
%  @arg Action an action's name (ground)
%  @arg State a action's precondition state

precond(buy,  [0,1,1,_,_,_]).
precond(comp, [1,1,1,1,1,1]).
precond(comp, [1,1,1,1,0,1]).
precond(doNo, [_,_,_,_,_,_]).
precond(lose, [1,_,1,_,_,_]).
precond(take, [0,_,1,_,_,_]).

%% perform(?Ini:state, ?New:state, ?Action) is semidet
%
%  Partial transition function.
%  'New' is the state tha would result by performing 'Action' from 'Ini'. 
%
%  @arg Ini an initial state.
%  @arg New a valid new state.
%  @arg Action action name (ground).

perform([0,1,1, Ic,Mc,Ac], [1,0,1, Ic,Mc,Ac], buy).
perform([1,1,1, 1,1,1], [1,0,1, 1,1,1], comp).
perform([1,1,1, 1,0,1], [1,0,1, 1,1,1], comp).
perform([1,Mh,1, Ic,Mc,Ac], [0,Mh,1, Ic,Mc,Ac], lose).
perform([0,Mh,1, 1,Mc,Ac], [1,Mh,1, 0,Mc,Ac], take).
perform([0,Mh,1, Ic,Mc,Ac], [0,Mh,0, Ic,Mc,Ac], doN).
perform([Ah,Mh,Ia, Ac,Mc,Ic], [Ah,Mh,Ia, Ac,Mc,Ic], doNo).
