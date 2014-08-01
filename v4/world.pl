% Define what subset of all possible states are taken
% to be a valid representation of a possible world.

% param State: State is a state as defined in state.pl
% param Ag: Ag is an agent, as defined in agents.pl

world(State-Ag):-
    agent(Ag),
    state(State),
    restriction(State).
