% file: aats.pl
% Action-based alternating transition system

% :- use_module(ag, [agents/1]).
% :- use_module(ac).    % Ac finite set of action for each agent ∈ Ag
% :- use_module(qi).    % 𝕢i designed initial state ∣ (𝕢i ∈ ℚ)

:- use_module(q).     % ℚ (the set of valid states)
:- use_module(gc).    % ℭ (the grand coalition)
:- use_module(jag).   % ⅉag joint action
:- use_module(acpre). % ρ (action precondition function)
:- use_module(trans). % τ (partial transition function)
:- use_module(val). % τ (partial transition function)



% ℒ (the language)

% agents
agent(hal).
agent(carla).

% coalition C ⊆ ℭ
coalition([carla, hal]).

% agent's attributes
attributes([i,m,a]).

% attribute's domanin
domain(i,[1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).

% 𝕢i initial state (must be 𝕢i ∈ ℚ)
% do we need this?
initial([0,1,1]).

% agent's actions
actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).
