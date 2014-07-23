__y(State-hal:a valid state, Action:List__

Finds the set of all `actions available` from a `given state`.
```
 y(State-Ag, State-PossibleAction):-
      state(State), agent(Ag),
      findall(Action, action(State-Ag, Action), PossibleAction),
      setFormat.
```
_Using 'state(State)' The list will contain some possible world from
which no action are defined_.

This is because, actions are bound to a subset of possible states and
not to all states we can possibly define.

Change `state(State)` with `world(State-Ag)` to see the list of all
possible worlds that admit one or more actions.
