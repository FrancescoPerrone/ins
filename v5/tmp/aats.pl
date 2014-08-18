% file: aats.pl
% Action-based alternating transition system

% Please consult one of the following:

% ac1.pl (action system with no active/passive, disti.)
% ac2.pl (action system with active/passive distiction)


% Ag (set of agents)
:- use_module(agents).
% ℚ (the set of valid states)
:- use_module(state).
% 𝕢 initial state file
:- use_module(inits).
% τ (partial transition function)
:- use_module(trans).
% v (values set and evaluation finction)
:- use_module(values).
