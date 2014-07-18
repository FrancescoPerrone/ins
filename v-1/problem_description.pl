/** 
 * <module> problem_description.pl
 * -------------------------------
 * This module implements a representation of Hal and Carla dilemma.

 * @author Francesco Perrone
 *
 */

agent(carla).
agent(hal).

state(Ag, State):-
    agent(Ag),
    State = s(I, M, A, W),
    bool(I),
    fbool(M),
    fbool(A),
    bool(W).

fbool(2).
fbool(1).
fbool(0).
bool(1).
bool(0).

%% Agent's attributes

%% NOTE: forse devi mettere valid_state(s(I,_,_,_))
%% Infatti se fai la query loses(hal) ti da true una volta
%% sola mentre forse dovrebbero essere tante quante
%% gli stati dove I = 1.
has_insulin(Ag, I):-
    agent(Ag),
    insulin(_, I).
insulin(s(I, _, _, _), I):-
    bool(I).

has_money(Ag, M):-
    agent(Ag),
    money(_, M).
money(s(_, M, _, _), M):-
    fbool(M).

%% evaluate if this version with the addition of
%% state(Ag, State) is better then the others. 
is_alive(Ag, A):-
    agent(Ag),
    alive(_, A).
alive(s(_, _, A, _), A):-
    fbool(A).

world(W):-
    w_attribute(_, W).
w_attribute(s(_, _, _, W), W):-
    bool(W).

%% Actions
lose(Ag, State):-
    State = s(1, _, A, _),
    is_alive(Ag, A), member(A, [1, 2]).
%% this is a cleaner version that uses the previous
%% predicates, but is is better?
lose1(Ag):-
    has_insulin(Ag, 1),
    is_alive(Ag, A), member(A, [1, 2]).

%% Other actions
compensate(Ag1, Ag2):-
    has_insulin(Ag1, 1),
    has_money(Ag1, M), member(M, [1,2]),
    is_alive(Ag1, A), member(A, [1,2]),
    agent(Ag2),
    not(Ag1 = Ag2).

take(Ag1, Ag2):-
    has_insulin(Ag1, 0),
    is_alive(Ag1, 1),
    has_insulin(Ag2, 1),
    not(Ag1 = Ag2).

buy(Ag, State):-
    State = s(0, M, A, 1),
    has_money(Ag, M), member(M, [1,2]),
    is_alive(Ag, A), member(A, [1,2]).

do_nothing(Ag, State):-
    state(Ag, State).
do_nothing(Ag, State):-
    agent(Ag),
    State = s(_, _, 0, _).
