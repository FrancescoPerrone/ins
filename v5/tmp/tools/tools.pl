:- module(tools, [c_state/1, combination_of/3]).
% I use this to create a new state C as
% all possible combitation of State1 and State2
% it is like initial/1 but more general.
% it can also create all state a given combination comes from.

combination_of(C, State1, State2):-
    state(State1), state(State2),
    C = [State1, State2].

% Generate a new 'state format' as the union
% of two possible states.

% c_state reads: coalition state.

% The new state format will be a list of lists of the kind:
% [[I,M,A], [I,M,A]]

c_state([StateA, StateP]):-
    state(StateA),
    state(StateP).
