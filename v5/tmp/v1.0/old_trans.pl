:- module(trans,[trans_label/4]).
:- use_module(library(pldoc)).

/** <module> Transition system

This file defines a set of rules for Hal-Carla scenario
to perform transition from state to state.

@author Francesco Perrone
@license GNU
*/

%% trans_aux(?Ini:state, ?Ac, ?New:state)
%
%  Transit of N step/s, from p to reach q. 
%  Means that from state 'Ini', we apply 'Ac' to
%  reach state 'New' which is 'N' step/s head of 'Ini'.
%
%  @arg Ini initial state
%  @arg Ac, performing action
%  @arg New a new state of affairs
%  
%  @see action.pl
%
trans_aux(Ini, Ac, New, 1):-
    perform(Ini, New, Ac).
trans_aux(Ini, Ac, New, N):-
    Step is N - 1,
    Step > 0,
    perform(Ini, Int, Ac),
    trans_aux(Int, Ac, New, Step).

trans_label(Init, A, V, New):-
    perform(Init, New, A),
    perform(Init, Nex, _),
    not(New = Nex),
    eval(New, Nex, V).
