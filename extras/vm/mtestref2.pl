% ℒ (the language)
attributes([i,m,a,s]).

domain(i, [1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [1,0]).

% ℚ (the set of valid states)

state(State):-
    attributes(Attributes),
    state2(Attributes, State). % aux predicate

state2([], []).
state2([Attribute|Rest], [Val|More]):-
    domain(Attribute, Dom),
    member(Val, Dom),
    state2(Rest, More).

% ℘ (the representation)

% specifies the pattern in the list representing a state
% General definition for value:

value(Attribute, State, Val):-
    attributes(Attributes),
    value4(Attribute, Attributes, State, Val).

value4(Attribute, [Attribute|_], [Val|_],Val):-
    domain(Attribute,Dom),
    member(Val, Dom).
value4(Attribute, [_|MoreAttributes], [_|RestState], Val):-
    value4(Attribute, MoreAttributes, RestState, Val).
