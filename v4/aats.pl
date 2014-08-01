% ACTION-BASED ALTERNATING TRANSITION SYSTEM

% Tools for basic list manipulation
:- include(list_manip).

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
% CONFIRM
actions(Set-Ag):-
    setof(Action, State^(action(State-Ag, Action)), Set),
    formatOutput.

% ρ (action precondition function)
actionpc(Set, Action):-
    setof(State, Ag^(action(State-Ag, Action)), Set),
    formatOutput.

% JAg (set of joint action)
% CONFIRM
jaction(Set):-
    setof(J, (agent(Ag), actions(J-Ag)), Set),
    formatOutput.

% τ (partial system transition function)
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

% '+' meaning a value is promoted
% '-' meaning a value is demoted
% '@' meaning neautral with respect of a value
