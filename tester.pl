:- include(transitions).
:- include(insuline).

%% AGENTS' ACTIONS:
%% A formal description of all legal actions
%% available to a given agent.
%% Action are defined giving preconditions.

action_set([buy, comp, do_nothing, lose, take]).
state_set(Set):-
    findall(State, valid_state(State), Set).
agent_set(Set):-
    findall(Ag, agent(Ag), Set).
    

can_buy(Ag, State):-
    state(Ag, State),
    alive(State, 1),
    money(State, M), (M is 1; M is 2),
    world(State, 1),
    insulin(State, 0).

can_comp(Ag, State):-
    state(Ag, State),
    alive(State, 2),
    money(State, M), (M is 1; M is 2),
    world(State, _),
    insulin(State, 1).

can_take(Ag1, Ag2, State1, State2):-
    \+(Ag1 = Ag2),
    % hal
    insulin(State2, 0),
    money(State2, _),
    alive(State2, 1),
    world(State2, _),
    % carla
    insulin(State1, 1),
    money(State1, _),
    alive(State1, _),
    world(State1, _).

do_nothing(Ag, State):-
    state(Ag, State).

%% Define what agent Ag can do from a given state
legal_action(Ag, State, buy):-
    can_buy(Ag, State).
legal_action(Ag, State, comp):-
    can_comp(Ag, State).
legal_action(Ag, State, take):-
    agent(Ag1),
    valid_state(State1),
    can_take(Ag1, Ag, State1, State).  
legal_action(Ag, State, do_nothing):-
    do_nothing(Ag, State).


    
