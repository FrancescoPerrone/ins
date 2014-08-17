% file: acpre.pl
:- module(precon,[precondition/2]).

% ρ (action precondition function)

% for each action α ∈ Ac defines the set of states from which
% action α may be executed.

precondition(buy, [0, 1, 1]).
precondition(buy, [0, 2, 2]).

precondition(compensate, [1, 1, 1]).
precondition(compensate, [1, 2, 2]).

precondition(doNothing, [_,_,_]).
precondition(doNothing, [_, _, 0]).

precondition(lose, [1, _, _]).

precondition(take, [0, _, 1]).

% it is not clear if I need to specify all the conditions this way
% or if I can make it more general.
% In any case, this is something very specific to this scenario
% and does not make sense to make it general.
