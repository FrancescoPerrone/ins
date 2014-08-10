% File: ag.pl
:- module(ag,[agents/1]).

% Agents

%% agent(hal).
%% agent(carla).

% Ag (set of agents)

agents(Set):-
    setof(Ag, (agent(List), member(Ag, List)), Set).


% experimenting only.
% I want something like:

% Agents:
%   hal
%   carla
printSet([]):-  nl. 
printSet([X|L]):-
    write('Agents: '),
    tab(2),
    write(X),  nl, 
    printSet(L).
