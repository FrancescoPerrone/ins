:- [list_manip].

% attribute(Val, A)
% attribute A has Values Val

attribute([1,0]).
attribute([1,0]).
attribute([t,f]).


li(List):-
    attribute(Values),
    member(Val, Values).



state1(State):-
    State = [I,A,M],
    member(I, [1,0]),
    member(A, [t, f]),
    member(M, [2, 1]).

att(A):-
    member(A, [1,2]).
    







%% attributes(Set):-
%% 	  findall(A, attribute(_, A), Set).
    
