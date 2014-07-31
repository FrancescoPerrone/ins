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

%% Pick last element of a list
last(X, [X|[]]).
last(X, [_|T]):-
    last(X, T).

%% Pick head/tail in a list
pick(H, [H|T], T).

%% Stolen from AI tutorial... don't like to be here!!!
combine(Exps,Paths,NewPaths):-
    append(Exps,Paths,NewPaths).

%% Evaluation function which which defines the stauts
%% of a value, member of a set of values, after a transition
%% from an initial state to a final state.
%% eval(-Val, +Init:integer, +Fin:integer, +X)
%% Vset is a set of values.
eval(Val, Init, Fin, X):-
    values(Vset),
    member(X, Vset),
    ( (Fin > Init -> Val = +X);
      (Fin < Init -> Val = -X);
      (Fin = Init -> Val = nX) ),
    !.

%% Tail recursion.
%% This will give problems of instantiations
%% tidof(1, [X|_], X).
%% tidof(Index, [_|T], X):-
%%     Index is Step+1,
%%     tidof(Step, T, X).
