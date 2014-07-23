```
action/2
---------------------------------------------------------------------------------

Problem: The predicate action/2 as it is, is "contingent".

This is because it relies on the predicate world/1 (which creates a subset of all
possible world by applying the predicate restriction/1 on the set). As
a consequence, the predicate rho/2 and perform/3 are contingent.

TODO: change the predicate so as it is generally valid and delete
world/1.
```
```
rho/1
---------------------------------------------------------------------------------

Problem: The predicate rho/2 is "contingent".

See above for details.

TODO: Correct action/2
```
```
perform/3
_________________________________________________________________________________
Problem: The predicate perform/3 is "contingent".

See action/2 for details.

TODO: Correct action/2
```
```
Interpretation function - x/2 and pi/2

Problem: instantiate only with the worlds were insulin is 1, but works
fine when querying about states having insulin 0

Probably is a problem related with the nature of the otheretor *->/2.

TODO: find another solution for x and pi
TODO: rename properly x/2
```
