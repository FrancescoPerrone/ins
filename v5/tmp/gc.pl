% File: ag.pl
:- module(ag,[agents/1]).

% Agents

%% agent(hal).
%% agent(carla).

% ℭ (the grand coalition)
% This predicate when called returns the set of all agents.
% a coalition C is defined ad C ⊆ ℭ 

agents(Set):-
    setof(Ag, agent(Ag), Set).


% experimenting only.
% I wanted something like:

% Agents:
%   hal
%   carla

% needs refinement

printSet([]):-  nl. 
printSet([X|L]):-
    write('Agents: '),
    tab(2),
    write(X),  nl, 
    printSet(L).
