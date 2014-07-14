%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Insulin Problem Description                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Values of agent properties
%% 1 and 0 can be both red as respectively "true" and "false"
%% bool indicates a Boolean value
bool(1).
bool(0).
%% fbool indicates a fuzzy set of values
fbool(2).
fbool(1).
fbool(0).

%% permitted(hal, 'access carla''s house').
%% not_permitted(hal, 'access carla''s house').

%% Agents
agent(hal).
agent(carla).
%% I prefer this for as defines a set of agents
%% instead of many facts about single members of the same set
agents([hal, carla]).

%% Definition of a state
state(Ag, State):-
    agent(Ag),
    valid_state(State).

valid_state(s(I, M, A, W)):-
    bool(I),
    fbool(M),
    fbool(A),
    bool(W).
    %not((I = 1, (A = 1); (A = 0))).

in_state(hal, s(0, 1, 1, 0)).
in_state(carla, s(1, 1, 2, 0)).


goal(State, Feature, Value).

%% AGENTS' PROPERTIES
%% Here a formal description
insulin(s(I, _, _, _), I):-
    bool(I).

money(s(_, M, _, _), M):-
    fbool(M).

alive(s(_, _, A, _), A):-
    fbool(A).
   
world(s(_, _, _, W), W):-
    bool(W).

has_insulin(Ag, I):-
    insulin(_, I),
    agent(Ag).

has_money(Ag, M):-
    money(_, M),
    agent(Ag).

is_alive(Ag, A):-
    alive(_, A),
    agent(Ag).

justified(Action, Agent).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Notes                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This should be the new version:
%% alive(Ag, A):-
%%     state(Ag, s(_, _, A, _)),
%%     fbool(A).
