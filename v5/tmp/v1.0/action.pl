:- module(act, [perform/3]).
:- use_module(library(pldoc)).
%:- doc_save(., [recursive(true)]).

/** <module> Actions and action pre/post conditions.

This file gives a semantics for actions and actions'
pre/post conditions.

==
perform(precondition, postcondition, action)
e.g.:

?- perform(Init, Fin, buyH).
Init = [0, 1, 1, _G2063, _G2066, _G2069],
Fin = [1, 0, 1, _G2063, _G2066, _G2069].
==

@author Francesco Perrone
@license GNU
*/


%% perform(?Pre:state, ?Pos:state, ?Act:ground) is semidet
%
%  Actions and actions' pre/post conditions.
%  Meaning that from Pre, Pos is the state resulting by
%  performing Action.
%
%  @arg Ini Action's precondition
%  @arg New Action post-condition.
%  @arg Action Action's name.
%
perform([0,1,1,I,M,A], [1,0,1,I,M,A], buyH).
perform([1,1,1,0,M,1], [1,0,1,1,M,1], comH). 
perform([1,1,1,1,_,1], [1,0,1,1,1,1], comH).
perform([0,D,1,1,M,1], [1,D,1,0,M,1], takH).
perform([1,D,1,I,M,A], [0,D,1,I,M,A], losH).
perform([1,D,1,I,M,A], [1,D,1,I,M,A], doNH).
perform([C,D,0,I,M,A], [C,D,0,I,M,A], doNH).
perform([0,D,1,I,M,A], [0,D,0,I,M,A], doNH).

% NOTICE: 
%
% 1. Only an agent with money and insulin, might compAg
% 2. compH means: Hal buys Carla insulin, or gives her money if she's insulin
% 3. In any situation an agent might doNo
% 4. If an agent if dead can only doNo
% 5. An agent dies for lack of insulin, if it doNo   
