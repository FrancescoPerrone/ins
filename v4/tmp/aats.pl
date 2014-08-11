% file: aats.pl
% Action-based alternating transition system

%:- use_module(ag, [agents/1]).

:- use_module(q).     % ℚ (the set of valid states)
:- use_module(qi).    % qi designed initial state ∣ (qi ∈ ℚ)
:- use_module(gc).    % ℭ (the grand coalition)
:- use_module(jag).   % Jag joint action
:- use_module(acpre). % ρ (action precondition function)
% :- use_module(ac).  % Ac finite set of action for each agent ∈ Ag


% ℒ (the language)
% -----------------------------------------------------------

% agents
agent(hal).
agent(carla).

% agent's attributes
attributes([i,m,a,s]).

% attribute's domanin
domain(i,[1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [1,0]).

% agent's actions
actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).

