% file: acpre.pl
:- module(acpre,[precondition/2]).

% ρ (action precondition function)

% for each action α ∈ Ac defines the set of states from which
% action α may be executed.

precondition(buy, [0, 1, 1, 1]).
precondition(buy, [0, 2, 2, 1]).

precondition(compensate, [1, 1, 1, _]).
precondition(compensate, [1, 2, 2, _]).

precondition(doNothing, [_,_,_,_]).
precondition(doNothing, [_, _, 0, _]).

precondition(lose, [1, _, _, _]).

precondition(take, [0, _, 1, _]).
precondition(take, [0, _, 2, _]).

% it is not clear if I need to specify all the condition this way
% or if I can make it more general.
% In any case, this is something very specific to this scenario
% and does not make sense to make it general.
