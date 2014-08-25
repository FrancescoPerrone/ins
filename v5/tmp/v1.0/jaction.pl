:- module(jaction, [performj/3]).
:- use_module(library(pldoc)).

/** <module> J-action semantics

This file defines the semantics for joint actions
and their pre/post conditions.

@see action.pl 

@author Francesco Perrone
@license GNU

@tbd performj/3
*/

%% perf(?Pre:state, ?Pos:state, ?Jac)
%  @arg Pre j-action's precondition
%  @arg Pos j-action post-condition 
%  @arg Jac j-action's name
%
performj([0,1,1,1,1,1], [1,0,1,1,0,1], buyH-compC).
performj([0,1,1,1,D,1], [1,0,1,1,D,1], buyH-doNoC).
performj([0,1,1,C,D,0], [1,0,1,C,D,0], buyH-doNoC).
performj([0,1,1,0,D,1], [1,0,1,0,D,0], buyH-doNoC).
performj([0,1,1,1,M,A], [1,0,1,0,M,A], buyH-loseC).
performj([0,1,1,0,M,1], [1,0,1,1,M,1], buyH-takeC).

performj([1,1,1,0,1,1], [1,0,1,1,0,1], comH-buyC).
performj([1,1,1,1,M,1], [1,0,1,1,M,1], comH-doNoC).
performj([1,1,1,I,M,0], [1,0,1,I,M,0], comH-doNoC).
performj([1,1,1,0,M,1], [1,0,1,0,M,0], comH-doNoC).
performj([1,1,1,1,M,1], [1,0,1,0,M,1], comH-loseC).
performj([1,1,1,0,M,1], [1,0,1,1,M,1], comH-takeC).

performj([0,M,1,0,1,1], [1,M,1,1,0,1], doNoH-buyC). 
performj([I,M,0,0,1,1], [I,M,0,1,0,1], doNoH-buyC).
performj([0,M,1,0,1,1], [0,M,0,1,0,1], doNoH-buyC).
performj([0,M,1,1,1,1], [1,M,1,1,0,1], doNoH-compC).
performj([I,M,0,1,1,1], [I,M,0,1,0,1], doNoH-compC).
performj([0,M,1,1,1,1], [0,M,0,1,0,1], doNoH-compC).
performj([0,M,1,0,M,1], [1,M,1,1,M,1], doNoH-takeC).
performj([I,M,0,0,M,1], [I,M,0,1,M,1], doNoH-takeC).
performj([0,M,1,0,M,1], [0,M,0,1,M,1], doNoH-takeC).
performj([0,M,1,1,M,1], [1,M,1,0,M,1], doNoH-loseC).
performj([I,M,0,1,M,1], [I,M,0,0,M,1], doNoH-loseC).
performj([0,M,1,1,M,1], [0,M,0,0,M,1], doNoH-loseC).

performj([1,M,1,0,1,1], [0,M,1,1,0,1], loseH-buyC).
performj([1,M,1,1,1,1], [0,M,1,1,0,1], loseH-compC).
performj([1,M,1,1,D,1], [0,M,1,1,D,1], loseH-doNoC).
performj([1,M,1,C,D,0], [0,M,1,C,D,0], loseH-doNoC).
performj([1,M,1,0,D,1], [0,M,1,0,D,0], loseH-doNoC).
performj([1,M,1,0,D,1], [0,M,1,1,D,1], loseH-takeC).

performj([0,M,1,0,1,1], [1,M,1,1,0,1], takeH-buyC).
performj([0,M,1,1,1,1], [1,M,1,1,0,1], takeH-compC).
performj([0,M,1,1,M,1], [1,M,1,1,M,1], takeH-doNoC).
performj([0,M,1,I,M,0], [1,M,1,I,M,0], takeH-doNoC).
performj([0,M,1,0,M,1], [1,M,1,0,M,0], takeH-doNoC).
performj([0,M,1,1,D,1], [1,M,1,0,D,1], takeH-loseC).

% NOTICE
% the same rules defined for @see action.pl
% apply here for all individual components
% of the joint action. 
