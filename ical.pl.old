:- include(transitions).

end_condition(bye).

welcome:-
    write('Calculator is running'), nl, nl.

cl:-
    write('\e[H\e[2J').

st:-
    valid_state(s(I, M, A, W)),
    write(I), tab(2), 
    write(M), tab(2), 
    write(A), tab(2),
    write(W), nl,
    fail.
states_table.

tutor:-
    write('as'), tab(2), write('action set'), nl,
    write('cl'), tab(2), write('clean screen'), nl,
    write('st'), tab(2), write('int. state tab'), nl,
    nl,
    write('you can see this tutorial anytime'), nl,
    write('just type ''tutor'''), nl.

as(Set, State):-
    findall(Act, transient(State, Act, _), Set).
:- op(35, xfx, as).

do(st):- st, !.
do(tutor):- tutor, !.
do(as(Set, State)):- Set as State.
do(make):- make, !.
do(cl):- cl, !.
do(bye).
do(_):-
    write('Invalide command').


command:-
    write('\e[H\e[2J'),
    welcome,
    repeat,
    write('>> '),
    read(X),
    do(X), nl,
    end_condition(X).
command.
