% file: aats.pl
% Action-based alternating transition system

% :- use_module(ag, [agents/1]).
% :- use_module(ac).    % Ac finite set of action for each agent ∈ Ag

% ℚ (the set of valid states)
:- use_module(state).
% 𝕢 initial state
:- use_module(initial).
% ℭ (the grand coalition)
:- use_module(gc). 
% ⅉag joint action   
:- use_module(jag).
% ρ (action precondition function)
:- use_module(precon).
% τ (partial transition function)
:- use_module(trans).
% v (values set and evaluation finction)
:- use_module(values).

% ℒ (the language)

% agents
agent(hal).
agent(carla).

% coalition C ⊆ ℭ
coalition([carla, hal]).

% agent's actions
actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).
