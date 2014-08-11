% file: aats.pl
% Action-based alternating transition system

%:- use_module(ag, [agents/1]).

:- use_module(q).     % ℚ (the set of valid states)
:- use_module(qi).    % qi designed initial state ∣ (qi ∈ ℚ)
:- use_module(gc).    % ℭ (the grand coalition)
% :- use_module(ac).    % Ac finite set of action for each agent ∈ Ag
:- use_module(jag).   % Jag joint action
:- use_module(acpre). % ρ (action precondition function)


% Define a language below.

% ℒ (the language)

attributes([i,m,a,s]).

domain(i,[1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [1,0]).

% Ag (set of agents)
agent(hal).
agent(carla).

% Ac (set of action for each agent ∈ Ag)
actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).
