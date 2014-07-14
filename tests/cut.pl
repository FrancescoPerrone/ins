data(one).
data(two).
data(three).

raining(0).
wet(1).

cut_test_a(X):-
    data(X).
cut_test_a('last clause').

cut_test_b(X):-
    data(X), !.
cut_test_b('last clause').

not_data(X):-
    \+(data(X)).

umbrella :- raining(1) -> wet(1).
