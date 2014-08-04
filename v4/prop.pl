% Atomic proposition for Hal and Carla scenario
/*
ins(hal).
ins(carla).
ali(hal).
ali(carla).
mon(hal).
mon(carla).
sho(open).
*/

prop_var([Vlist], Ag, [State]):-
    agent(Ag),
    interpret(Vlist, State-Ag).
prop_var([_|T], Ag, States):-
    agent(Ag),
    pick(State, States, Rest),
    interpret(T, State-Ag),
    prop_var(T, Ag, Rest).
