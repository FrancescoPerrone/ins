% file: aats.pl
% Action-based alternating transition system

%:- use_module(ag, [agents/1]).

:- use_module(q).  % ℚ (the set of valid states)
:- use_module(qi). % initial state ∈ ℚ
:- use_module(ag). % Ag the set of agents


% Define a language below.

% ℒ (the language)

attributes([i,m,a,s]).

domain(i,[1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [1,0]).
