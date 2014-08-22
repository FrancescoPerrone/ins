:- module(trans,[trans/4, trans_label/5]).

/** <module> Transition system

This file defines a set of rules for Hal-Carla scenario
to perform transition from state to state.

@author Francesco Perrone
@license GNU
*/

%% trans(?Ini:state, ?Ac, ?New:state, +N:int)
%
%  Transit of N step/s, from p to reach q. 
%  Means that from state 'Ini', we apply 'Ac' to
%  reach state 'New' which is 'N' step/s head of 'Ini'.
%
%  @arg Ini initial state
%  @arg Ac, performing action
%  @arg New a new state of affairs
%  @arg N int specifying the number of step/s taken by the transition
%  
%  @see action.pl

trans(Ini, Ac, New, 1):-
    precond(Ac, Ini),
    perform(Ini, New, Ac).

%% trans_label(?Ini, ?Ac, ?V, ?Na, +N)
%
%  Transit of N step/s, from p to reach q. 
%  Means that from state 'Ini', we apply 'Ac' to
%  reach state 'New' which is 'N' step/s head of 'Ini'.
%
%  @arg Ini initial state
%  @arg Ac, performing action
%  @arg V one of Hal's values
%  @arg Na a new state of affairs
%  @arg N int specifying the number of step/s taken by the transition
%  
%  @see val.pl

trans_label(Ini, Ac, V, Na, 1):-
    trans(Ini, Ac, Na, 1),
    trans(Ini, Ac, Nb, 1),
    eval(Na, Nb, V).
