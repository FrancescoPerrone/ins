:- include(insuline).
%% A transient is a short-lived even,
%% or a  quantum in a transitionary chain.
%% It is therefore the shortest paths from an initial
%% state to another state that we have, by apply
%% an action from the initial state.

%% buy
transient(s(0, 2, 1, 1), buy, s(1, 1, 1, 1)).
transient(s(0, 1, 1, 1), buy, s(1, 0, 1, 1)).
%% compensate
transient(s(1, 2, 2, 1), comp, s(1, 1, 2, 1)).
transient(s(1, 2, 2, 0), comp, s(1, 1, 2, 0)).
transient(s(1, 1, 2, 1), comp, s(1, 0, 2, 1)).
transient(s(1, 1, 2, 0), comp, s(1, 0, 2, 0)).
transient(s(1, M1, A1, W1), lose, s(0, M2, A2, W2)):-
    M2 = M1, fbool(M2), fbool(M1),
    A2 = A1,
    W2 = W1, bool(W1), bool(W2).
%% take
transient(s(0, M1, 1, 0), take, s(I2, M2, A2, 0)):-
    I2 = 1, 
    M2 = M1, fbool(M2), fbool(M1),
    A2 = 2, 
    W2 = W1, bool(W1), bool(W2).
%% do_nothing
transient(s(1, M, A, W), do_nothing, s(1, M, A, W)).
transient(s(0, M, 1, W), do_nothing, s(0, M, 0, W)).
% this last fact need verification. look at paper.
transient(s(0, M, 2, W), do_nothing, s(0, M, 1, W)).

%% this fails here. Why? 
%% 18 ?- transient(s(1, 1, 1, 1), do_nothing, s(1, 1, 1, 1)).
%% true 
%% false.
%% 19 ?- transient(s(1, 1, 1, 1), do_nothing, s(1, 1, 1, 1)).
%% true 
%% false.

%% A time_step of lenght 1 is therefore the shortest
%% transition possible, i.e. a transient:
time_step_lenght(Initial, Action, Next, 1):-
    transient(Initial, Action, Next).
%% a time_step of Lenght N is defined as follows
time_step_lenght(Initial, Action, Next, N):-
    Step is N - 1,
    Step > 0,
    transient(Initial, Action, Inter),
    time_step_lenght(Inter, Action, Next, Step).

act_set(Set, State):-
    findall(Act, transient(State, Act, _), Set).

%% act_set([], State).
%% act_set([Action], State):-
%%     transient(State, Action, _).
