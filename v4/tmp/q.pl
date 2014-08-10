% file: q.pl
:- module(q, [state/1, states/1, attribute/3]).
% q.pl require a language to work.
% A language should be defined in aats.pl

%% attributes([i,m,a,s]).

%% domain(i,[1,0]).
%% domain(m, [2,1,0]).
%% domain(a, [2,1,0]).
%% domain(s, [1,0]).

% ℚ (set of all possible states)

states(Set):-
    findall(S, state(S), Set).


% ℜ (the representation)

state(State):-
    attributes(Attributes),
    state_aux(Attributes, State).

state_aux([],[]).
state_aux([Attribute|Attributes],[Val|Values]):-
    domain(Attribute, Dom),
    member(Val, Dom),
    state_aux(Attributes, Values).

% specifies the order in a state

attribute(Attribute, State, Val):-
    attributes(Attributes),
    attribute_aux(Attribute, Attributes, State, Val).

attribute_aux(Attribute, [Attribute|_], [Val|_], Val):-
    domain(Attribute, Dom),
    member(Val, Dom).
attribute_aux(Attribute, [_|MoreAttributes], [_|RestStates], Val):-
    attribute_aux(Attribute, MoreAttributes, RestStates, Val).

