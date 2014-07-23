__y(State-hal:a valid state, Action:List)__

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


__transient(State-Ag-Set, 1)__

Example output:

    ?- transient(_-hal-Set, 1).
    Set = [1, 2, 2, 1]-[lose, compensate, doNothing] ;
    Set = [1, 2, 2, 0]-[lose, compensate, doNothing] ;
    Set = [1, 2, 2, 1]-[lose, compensate, doNothing] ;
    Set = [1, 2, 2, 0]-[lose, compensate, doNothing] ;
    Set = [1, 1, 2, 1]-[lose, compensate, doNothing] ;
    Set = [1, 1, 2, 0]-[lose, compensate, doNothing] ;
    Set = [1, 0, 2, 1]-[lose, doNothing] ;
    Set = [1, 0, 2, 0]-[lose, doNothing] ;
    Set = [0, 2, 1, 1]-[take, buy, doNothing] ;
    Set = [0, 2, 1, 0]-[take, doNothing] ;
    Set = [0, 2, 0, 1]-[doNothing] ;
    Set = [0, 2, 0, 0]-[doNothing] ;
    Set = [0, 1, 1, 1]-[take, buy, doNothing] ;
    Set = [0, 1, 1, 0]-[take, doNothing] ;
    Set = [0, 1, 0, 1]-[doNothing] ;
    Set = [0, 1, 0, 0]-[doNothing] ;
    Set = [0, 0, 1, 1]-[take, doNothing] ;
    Set = [0, 0, 1, 0]-[take, doNothing] ;
    Set = [0, 0, 0, 1]-[doNothing] ;
    Set = [0, 0, 0, 0]-[doNothing].
    Set = [1, 1, 2, 1]-[lose, compensate, doNothing] ;
    Set = [1, 1, 2, 0]-[lose, compensate, doNothing] ;
    Set = [1, 0, 2, 1]-[lose, doNothing] ;
    Set = [1, 0, 2, 0]-[lose, doNothing] ;
    Set = [0, 2, 1, 1]-[take, buy, doNothing] ;
    Set = [0, 2, 1, 0]-[take, doNothing] ;
    Set = [0, 2, 0, 1]-[doNothing] ;
    Set = [0, 2, 0, 0]-[doNothing] ;
    Set = [0, 1, 1, 1]-[take, buy, doNothing] ;
    Set = [0, 1, 1, 0]-[take, doNothing] ;
    Set = [0, 1, 0, 1]-[doNothing] ;
    Set = [0, 1, 0, 0]-[doNothing] ;
    Set = [0, 0, 1, 1]-[take, doNothing] ;
    Set = [0, 0, 1, 0]-[take, doNothing] ;
    Set = [0, 0, 0, 1]-[doNothing] ;
    Set = [0, 0, 0, 0]-[doNothing].
