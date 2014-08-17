:- module(agents, [agent/1, coalition/1]).

% agents
agent(hal).
agent(carla).

% coalition C ⊆ ℭ
coalition([hal, carla]).
