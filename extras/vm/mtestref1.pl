% ℒ (the language)
attributes([i,m,a,s]).

domain(i, [1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [t,f]).

% ℘ (the representation)

% specifies the pattern in the list representing a state

attribute(i, State, Val):-
    State = [Val,_,_,_].

attribute(m, State, Val):-
    State = [_,Val,_,_].

attribute(a, State, Val):-
    State = [_,_,Val,_].

attribute(s, State, Val):-
    State = [_,_,_,Val].

% General definition for value:

value(Attribute, State, Val):-
    attribute(Attribute, State, Val),
    domain(Attribute, Dom),
    member(Val, Dom).

% defines a valid state

state(State):-
    value(i, State, _),
    value(m, State, _),
    value(a, State, _),
    value(s, State, _).
