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
performj([0,1,1,1,1,1], [1,0,1,1,0,1], buyH-comC).
performj([0,1,1,1,D,1], [1,0,1,1,D,1], buyH-doNC).
performj([0,1,1,C,D,0], [1,0,1,C,D,0], buyH-doNC).
performj([0,1,1,0,D,1], [1,0,1,0,D,0], buyH-doNC).
performj([0,1,1,1,M,A], [1,0,1,0,M,A], buyH-losC).
performj([0,1,1,0,M,1], [1,0,1,1,M,1], buyH-takC).

performj([1,1,1,0,1,1], [1,0,1,1,0,1], comH-buyC).
performj([1,1,1,1,M,1], [1,0,1,1,M,1], comH-doNC).
performj([1,1,1,I,M,0], [1,0,1,I,M,0], comH-doNC).
performj([1,1,1,0,M,1], [1,0,1,0,M,0], comH-doNC).
performj([1,1,1,1,M,1], [1,0,1,0,M,1], comH-losC).
performj([1,1,1,0,M,1], [1,0,1,1,M,1], comH-takC).


performj([1,M,1,0,1,1], [1,M,1,1,0,1], doNH-buyC). 
performj([I,M,0,0,1,1], [I,M,0,1,0,1], doNH-buyC).
performj([0,M,1,0,1,1], [0,M,0,1,0,1], doNH-buyC).

performj([1,M,1,1,1,1], [1,M,1,1,0,1], doNH-comC).
performj([0,M,1,1,1,1], [0,M,0,1,0,1], doNH-comC).
performj([0,M,1,0,M,1], [0,M,0,1,M,1], doNH-takC).

performj([1,M,1,0,M,1], [1,M,1,1,M,1], doNH-takC).
performj([I,M,0,0,M,1], [I,M,0,1,M,1], doNH-takC).
performj([0,M,1,1,M,1], [0,M,0,0,M,1], doNH-losC).

% need fixed doNH-losC give unexpected repetitions
performj([1,M,1,1,M,1], [1,M,1,0,M,1], doNH-losC).
performj([I,M,0,1,M,1], [I,M,0,0,M,1], doNH-losC).
performj([0,M,1,1,M,1], [0,M,0,0,M,1], doNH-losC).



performj([1,M,1,0,1,1], [0,M,1,1,0,1], losH-buyC).
performj([1,M,1,1,1,1], [0,M,1,1,0,1], losH-comC).
performj([1,M,1,1,D,1], [0,M,1,1,D,1], losH-doNC).
performj([1,M,1,C,D,0], [0,M,1,C,D,0], losH-doNC).
performj([1,M,1,0,D,1], [0,M,1,0,D,0], losH-doNC).
performj([1,M,1,0,D,1], [0,M,1,1,D,1], losH-takC).

performj([0,M,1,0,1,1], [1,M,1,1,0,1], takH-buyC).
performj([0,M,1,1,1,1], [1,M,1,1,0,1], takH-comC).
performj([0,M,1,1,M,1], [1,M,1,1,M,1], takH-doNC).
performj([0,M,1,I,M,0], [1,M,1,I,M,0], takH-doNC).
performj([0,M,1,0,M,1], [1,M,1,0,M,0], takH-doNC).
performj([0,M,1,1,D,1], [1,M,1,0,D,1], takH-losC).

% NOTICE
% the same rules defined for @see action.pl
% apply here for all individual components
% of the joint action. 
