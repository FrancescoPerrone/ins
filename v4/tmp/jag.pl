% file: jag.pl
:- module(jag, [jointac/2]).


% ⅉag (joint action)

% this works for two agents only. Needs to be improved
% to a general case.

jointac([], [_|[]]).
jointac([Jointac], [Agent1, Agent2|_]):-
    alpha(Ac1-Agent1),
    alpha(Ac2-Agent2),
    not(Agent1 = Agent2),
    Jointac = [Ac1-Agent1, Ac2-Agent2].


% auxiliary predicate
alpha(Ac-Ag):-
    actions(Ag, List),
    member(Ac, List).
