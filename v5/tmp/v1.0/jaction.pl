:- module(jaction, [precon/2, perfor/3]).
:- use_module(library(pldoc)).

/** <module> J-action semantics

This file defines the semantics for joint actions
and their pre/post conditions.

@see action.pl 

@author Francesco Perrone
@license GNU

@tbd perform/3
*/

%% perf(?Pre:state, ?Pos:state, ?Jac)
%  @arg Pre j-action's precondition
%  @arg Pos j-action post-condition 
%  @arg Jac j-action's name
%
perform([0,1,1,1,1,1], [1,0,1,1,0,1], buyH-compC).
perform([0,1,1,1,D,1], [1,0,1,1,D,1], buyH-doNoC).
perform([0,1,1,C,D,0], [1,0,1,C,D,0], buyH-doNoC).
perform([0,1,1,0,D,1], [1,0,1,0,D,0], buyH-doNoC).
perform([0,1,1,1,M,A], [1,0,1,0,M,A], buyH-loseC).
perform([0,1,1,0,M,1], [1,0,1,1,M,1], buyH-takeC).

perform([1,1,1,0,1,1], [1,0,1,1,0,1], comH-buyC).
perform([1,1,1,1,M,1], [1,0,1,1,M,1], comH-doNoC).
perform([1,1,1,I,M,0], [1,0,1,I,M,0], comH-doNoC).
perform([1,1,1,0,M,1], [1,0,1,0,M,0], comH-doNoC).
perform([1,1,1,1,M,1], [1,0,1,0,M,1], comH-loseC).
perform([1,1,1,0,M,1], [1,0,1,1,1,1], comH-takeC).

perform([0,M,1,0,1,1], [1,M,1,1,0,1], doNoH-buyC). 
perform([I,M,0,0,1,1], [I,M,0,1,0,1], doNoH-buyC).
perform([0,M,1,0,1,1], [0,M,0,1,0,1], doNoH-buyC).
perform([0,M,1,1,1,1], [1,M,1,1,0,1], doNoH-compC).
perform([I,M,0,1,1,1], [I,M,O,1,0,1], doNoH-compC).
perform([0,M,1,1,1,1], [0,M,0,1,0,1], doNoH-compC).
perform([0,M,1,0,M,1], [1,M,1,1,M,1], doNoH-takeC).
perform([I,M,0,0,M,1], [I,M,0,1,M,1], doNoH-takeC).
perform([0,M,1,0,M,1], [0,M,0,1,M,1], doNoH-takeC).
perform([0,M,1,1,M,1], [1,M,1,0,M,1], doNoH-loseC).
perform([I,M,0,1,M,1], [I,M,0,0,M,1], doNoH-loseC).
perform([0,M,1,1,M,1], [0,M,0,0,M,1], doNoH-loseC).

perform([1,M,1,0,1,1], [0,M,1,1,0,1], loseH-buyC).
perform([1,M,1,1,1,1], [0,M,1,1,0,1], loseH-compC).
perform([1,M,1,1,D,1], [0,M,1,1,D,1], loseH-doNoC).
perform([1,M,1,C,D,0], [0,M,1,C,D,0], loseH-doNoC).
perform([1,M,1,0,D,1], [0,M,1,0,D,0], loseH-doNoC).
perform([1,M,1,0,D,1], [0,M,1,1,D,1], loseH-takeC).

perform([0,M,1,0,1,1], [1,M,1,1,0,1], takeH-buyC).
perform([0,M,1,1,1,1], [1,M,1,1,0,1], takeH-compC).
perform([0,M,1,1,M,1], [1,M,1,1,M,1], takeH-doNoC).
perform([0,M,1,I,M,0], [1,M,1,I,M,0], takeH-doNoC).
perform([0,M,1,0,M,1], [1,M,1,0,D,0], takeH-doNoC).
perform([0,M,1,1,D,1], [1,M,1,0,D,1], takeH-loseC).

% NOTICE
% the same rules defined for @see action.pl
% apply here for all individual components
% of the joint action. 
