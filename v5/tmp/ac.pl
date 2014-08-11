% file: ac.pl
:- module(ac, [actions/2]).

% here it is not clear wheter this should be a rule of form reported below
% or a laguage definiton like:

% action(hal, [..,..,..])

%% actions(I, [buy, compensate, doNothing, lose, take]):-
%%     agents(Ag),
%%     member(I, Ag).

actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).
