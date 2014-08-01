%% Append and Member of

%% Fact or base case.
mem(X, [X|_]).
%% Recursive rule. 
mem(X, [_|T]):-
    member(X, T).

app(X, [], [X]).
app(X, [H|T], [H|T2]):-
    app(X, T, T2).

%% Index of elements in a lists:

%% finds all occurances
idof(1, [X|_], X).
idof(Index, [_|T], X):-
    idof(Step, T, X),
    Index is Step+1.

%% finds only first occurance
fidof(1, [X|_], X):- !.
fidof(Index, [_|T], X):-
    fidof(Step, T, X),
    !,
    Index is Step+1.

last(X, [X|[]]).
last(X, [_|T]):-
    last(X, T).


%% Tail recursion.
%% This will give problems of instantiations
%% tidof(1, [X|_], X).
%% tidof(Index, [_|T], X):-
%%     Index is Step+1,
%%     tidof(Step, T, X).
