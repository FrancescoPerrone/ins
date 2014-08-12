% file: jag.pl
:- module(jag, [jact/2]).

% ⅉag (joint action)

% Temporary solution. Needs generalisation.

% a joint action is a tuple of alphas such that there are no two
% different action that belong to the same agent

jact([], [_|[]]).
jact(Jointac, [Agent1, Agent2|_]):-
    alpha(Ac1-Agent1),
    alpha(Ac2-Agent2),
    not(Agent1 = Agent2),
    Jointac = [Ac1, Ac2].

% auxiliary predicate

% for all alpha there is an agent Ag such that
% an action Ac is contained in the set of Ag's actions.

alpha(Ac-Ag):-
    actions(Ag, List),
    member(Ac, List).
