% ACTION-BASED ALTERNATING TRANSITION SYSTEM

% Q (set of states)
states(Set):-
    findall(S, state(S), Set),
    formatOutput.

% q0 (initial state in Q)
initial(I):-
    states(States),
    member(I, States).

% Ag (set of agents)
agents(Set):-
    findall(A, agent(A), Set),
    formatOutput.

% Ac (set of actions for each agent)
% TO DOUBLE-CHECK
actions(Set, Ag):-
    agent(Ag),
    setof(Action-Ag, State^(action(State-Ag, Action)), Set),
    formatOutput.

% JAg (set of joint action)
% TO DOUBLE-CHECK
jactions(Set):-
    findall(Jact-Ag, actions(Jact, Ag), Set),
    formatOutput.

% ρ (action precondition function)
actionpc([Action], Ag, Precon):-
    action(Precon-Ag, Action).
actionpc(Act, Ag, Precon):-
    actions(Set, Ag),
    pick(Act, Set, Rest),
    action(Precon-Ag, Act),
    actionpc(Rest, Ag, Precon).
    

% τ (partial system transition function)
% (requires perform definition. see actions.pl)
transient(Init-Ag, Act-->Next-Ag):-
    perform(Init-Ag, Next, Act),
    world(Next-Ag).
transient(State-Ag, [Act|Acts]-->Next-Ag):-
    statepc(State-Ag, State-Acts),
    pick(Act, Acts, Rest),
    transient(State-Ag, Rest-->Next-Ag).

statepc(State-Ag, State-Actions):-
    agent(Ag),
    state(State),
    findall(Action, action(State-Ag, Action), Actions),
    formatOutput.

% ϕ (set of atomic propositions)
% see prop.pl

% π (interpretation funcion)
% see state.pl

% Aυ (set of valus)
values(Set):-
    setof(V, value(V), Set),
    formatOutput.

% δ (valuation function)
% Defines the stauts of a value after a transition
eval(Status, Init, Fin, Value):-
    values(Values), 
    member(Value, Values),
    ( (Fin > Init -> Status = +Value);
      (Fin < Init -> Status = -Value);
      (Fin = Init -> Status = @Value) ),
    !.
