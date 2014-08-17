% file: qi.pl
:- module(initial, [initial/1]).

% agents' initial state
init(carla, [1,_,1]).
init(hal, [0,_,1]).

% Give all initial states for a 
% coalition in a particula scenario
% determined by init/2 above.

% cstate([A, B]), A = [0,_,1], B = [1,_,1].
initial(Init):-
    cstate([A, B]), 
    init(hal, A), 
    init(carla, B), 
    Init = [A, B].

% Create the superset of all possible states for the 
% coalition.
cstate([StateA, StateP]):-
    state(StateA),
    state(StateP).
