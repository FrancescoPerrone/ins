:-module(actionap, [status/2]).

% meaning that an agent is an a particula status).
status(hal, active).
status(carla, passive).

% active/passive actions
actions(active, [buy, compensate, doNothing, take]).
actions(passive, [buy, doNothing]).

% the set of action available to each agent
ac_set(Ag, Ac):-
    status(Ag, Status),
    actions(Status, Ac).

% action preconditions

precon(take-A, [Active-A, Passive-P]):-
    coalition(C),
    member(A, C), status(A, active),
    member(P, C), status(P, passive),
    Active = [0,_,1],
    init(P, Passive),
    Passive = [1,_,1].

precon(compensate-A, [Active-A, Passive-P]):-
    coalition(C),
    member(A, C), status(A, active),
    member(P, C), status(P, passive),
    Active = [1,1,1],
    init(P, Passive),
    Passive = [_,_,1].

precon(buy-A, [[0,1,1]-A, []]):-
    agent(A).

precon(doNothing-A, [State-A, []]):-
    agent(A),
    state(State).

% perform action

perf([Active, Passive], [NewAct, NewPas], take):-
    Active =  [0,M,1],
    Passive = [1,M,1],
    NewAct =  [1,M,1],
    NewPas =  [0,M,1].

perf([Active, Passive], [NewAct, NewPas], compensate):-
    Active =  [1,1,1],
    Passive = [_,_,1],
    NewAct =  [1,0,1],
    NewPas =  [_,1,1].

perf([Init, []], [New, []], buy):-
    Init = [0,1,1],
    New =  [1,0,1].

perf([Init, []], [New, []], doNothing):-
    state(Init), state(New),
    Init = [I, M, A],  New = [I, M, An], 
    (
	(A = 1, I = 0) *-> An = 0;
	An = A
    ).
