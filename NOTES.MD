##### y(State-hal:a valid state, Action:List)
###### Find the set of all actions available from a given state.
```
 y(State-Ag, State-PossibleAction):-
      state(State), agent(Ag),
      findall(Action, action(State-Ag, Action), PossibleAction),
      setFormat.
```

As it is, this predicate could return a list of all action available
from a given state: 'state(State)'. The list will contain some state
from which no action is defined. This is because the action available
is dependant on the restriction/2 defined for the set of all possible
worlds.

If we change `state(State)` with `world(State-Ag)` the predicate only
find those states for which one or more actions are available.
