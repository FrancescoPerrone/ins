/** 
 * <module> problem_description.pl
 * -------------------------------
 * This module implements a representation of Hal and Carla dilemma.

 * @author Francesco Perrone */

%% attribute's values
fbool(2).
fbool(1).
fbool(0).
bool(1).
bool(0).

%% agents
agent(carla).
agent(hal).

%% Agent's attributes

%% NOTE: forse devi mettere valid_state(s(I,_,_,_))
%% Infatti se fai la query loses(hal) ti da true una volta
%% sola mentre forse dovrebbero essere tante quante
%% gli stati dove I = 1.
has_insulin(Ag, I):-
    agent(Ag),
    insulin(_, I),
insulin(s(I, _, _, _), I):-
    bool(I).

has_money(Ag, M):-
    agent(Ag),
    money(_, M).
money(s(_, M, _, _), M):-
    valid_state(s(_, M, _, _)),
    fbool(M).

is_alive(Ag, A):-
    agent(Ag),
    alive(_,A).
alive(s(_, _, A, _), A):-
    fbool(A).

world(W):-
    w_attribute(_, W).
w_attribute(s(_, _, _, W), W):-
    bool(W).

%% Agent's state(+State)
state(State):-
    valid_state(State).

%% valid_state(+State:a state)
valid_state(s(I, M, A, W)):-
    bool(I),
    fbool(M),
    fbool(A),
    bool(W).
