append([], X, X).
append([H|T1], X, [H|T2]):-
    append(T1, X, T2).

member(H, [H |_]).
member(X, [_ |T]):-
    member(X, T).
