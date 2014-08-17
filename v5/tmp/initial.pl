% file: qi.pl
:- module(initial, [initial/1]).

% agents' initial state
init(carla, [1,_,1]).
init(hal, [0,_,1]).

% gives all possible initial states
% of a particular scenario:
% cstate([A, B]), A = [0,_,1], B = [1,_,1].
initial(Init):-
    cstate([A, B]), 
    init(hal, A), 
    init(carla, B), 
    Init = [A, B].

% Colition's state
cstate([StateA, StateP]):-
    state(StateA),
    state(StateP).
