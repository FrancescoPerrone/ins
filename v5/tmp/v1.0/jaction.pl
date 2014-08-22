:- module(jaction, [precon/2, perfor/3]).
:- use_module(library(pldoc)).

/** <module> Action precondition and partial transition function

This file provides actions, and their precondition/transition
functions.

@author Francesco Perrone
@license GNU

@tbd precon/2
@tbd perform/3
*/

%% precon(?Action, ?State:state) is semidet
%
%  Meaning that Action can be performed
%  from State.
%
%  @arg Action an action name (ground)
%  @arg State a action's precondition state
 
precon([buyH,compC], [0,1,1,1,1,1]).
precon([buyH,doNoC], [0,1,1,_,_,_]).
precon([buyH,loseC], [0,1,1,1,_,1]).
precon([buyH,takeC], [0,1,1,1,_,1]).

precon([comH,buyC],  [1,1,1,0,1,1]).
precon([comH,doNoC], [1,1,1,_,_,_]).
precon([comH,loseC], [1,1,1,1,_,1]).
precon([comH,takeC], [1,1,1,0,_,1]).

precon([doNoH,buyC],  [_,_,_,0,1,1]).
precon([doNoH,compC], [_,_,_,1,1,1]).
precon([doNoH,loseC], [_,_,_,1,_,1]).
precon([doNoH,takeC], [_,_,_,0,_,1]).

precon([loseH,buyC],  [1,_,1,0,1,1]).
precon([loseH,compC], [1,_,1,1,1,1]).
precon([loseH,doNoC], [1,_,1,_,_,_]).
precon([loseH,takeC], [1,_,1,0,_,1]).

precon([takeH,buyC],  [0,_,1,0,1,1]).
precon([takeH,compC], [0,_,1,1,1,1]).
precon([takeH,doNoC], [0,_,1,_,_,_]).
precon([takeH,loseC], [0,_,1,1,_,1]).


%% perf(?Ini:state, ?New:state, ?Jac)
%  @arg Ini initial state
%  @arg New final state result of Jac
%  @arg Jac joint action

/*
perform([0,1,1,I,A,M], [1,0,1,1,0,1], [buyH,compC]).
perform([0,1,1,0,M,1], [1,0,1,0,M,0], [buyH,doNoC]).
perform([0,1,1,1,M,1], [1,0,1,1,M,1], [buyH,doNoC]).
perform([0,1,1,1,M,A], [1,0,1,0,M,A], [buyH,loseC]).
perform([0,1,1,0,M,A], [1,0,1,1,M,A], [buyH,takeC]).

perform([1,1,1,0,1,1], [1,0,1,1,0,1], [comH,buyC] ).
perform([1,1,1,0,M,1], [1,0,1,0,M,0], [comH,doNoC]).
perform([1,1,1,1,M,A], [1,0,1,1,M,A], [comH,doNoC]).
perform([1,1,1,1,M,1], [1,0,1,0,M,1], [comH,loseC]).
perform([1,1,1,0,M,1], [1,0,1,1,M,1], [comH,takeC]).

perform([0,M,1,0,1,1], [0,M,0,1,0,1], [doNoH,buyC] ). 
perform([1,M,A,0,1,1], [1,M,A,1,0,1], [doNoH,buyC] ).
perform([0,M,1,1,1,1], [0,M,0,1,0,1], [doNoH,compC]).
perform([1,M,A,1,1,1], [1,M,A,1,0,1], [doNoH,compC]).
perform([0,M,1,0,M,1], [0,M,0,1,M,1], [doNoH,takeC]).
perform([1,M,A,1,M,1], [1,M,A,0,M,1], [doNoH,loseC]).


perfor([1,M,1,0,1,1], [0,M,1,1,1,1], [loseH,buyC]).
perfor([1,M,1,1,1,1], [0,M,1,1,1,1], [loseH,compC]).
perfor([1,A,1,0,B,1], [0,A,1,0,B,0], [loseH,doNoC]).
perfor([1,A,1,1,B,C], [0,A,1,1,B,C], [loseH,doNoC]).
perfor([1,A,1,0,B,1], [0,A,1,1,B,1], [loseH,takeC]).

perfor([0,M,1,1,B,A], [1,M,1,1,1,1], [takeH,buyC]).
perfor([0,M,1,1,1,1], [1,M,1,1,0,1], [takeH,compC]).
perfor([0,A,1,_,B,_],,[takeH,doNoC]).
perfor([0,A,1,1,B,1],,[takeH,loseC],).
*/
