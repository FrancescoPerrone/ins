% ℒ (the language)
attributes([i,m,a,s]).

domain(i, [1,0]).
domain(m, [2,1,0]).
domain(a, [2,1,0]).
domain(s, [t,f]).

% ℘ (the representation)

%The order in the list in which attributes appear.
% Given an attribute and a representation of a state
% gives the corresponding value

%value(Attribute, State, Val).

value(i, State, Val):-
    State = [Val,_,_,_],
    domain(i,Dom),
    member(Val, Dom).

value(m, State, Val):-
    State = [_,Val,_,_],
    domain(m,Dom),
    member(Val, Dom).

value(a, State, Val):-
    State = [_,_,Val,_],
    domain(a,Dom),
    member(Val, Dom).

value(s, State, Val):-
    State = [_,_,_,Val],
    domain(s,Dom),
    member(Val, Dom).

% defines a valid state

state(State):-
    value(i, State, _),
    value(m, State, _),
    value(a, State, _),
    value(s, State, _).
