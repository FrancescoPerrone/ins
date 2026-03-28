# TODO — Implementation Gaps (Priority Order)

---

## 1. Fix `arg/2` duplicate results (args.pl) — BLOCKER

The solution files (`docs/solutions/arg.sol`, `arg2.sol`) show each argument is returned
multiple times (e.g. `[buyH, losH]` appears twice, `[takH, losH]` four times).
This is caused by the double-negation trick in `arg/2` triggering on multiple
unifications. The predicate needs to be rewritten to produce each `(Acts, Val)` pair
exactly once, likely using `setof/3` or explicit cuts.

---

## 2. Fix `doNH-losC` duplicate clauses (jactions.pl) — BUG

Lines 47 and 52 are identical:

```prolog
performj([0,M,1,1,M,1], [0,M,0,0,M,1], doNH-losC).
```

This causes unexpected repeated solutions. One clause must be removed or the
precondition distinguished.

---

## 3. Fix `demotes/4` hardcoded agent (values.pl) — BUG

```prolog
demotes(Ag, S1, S2, -Val):-
    agent(Ag),
    worse(hal, S1, S2, Val).   % <-- should be Ag, not hal
```

`eval/4` will give wrong results for any agent other than Hal.

---

## 4. Wire joint actions into `trans.pl` — MISSING FEATURE

`trans.pl` only calls `perform/3` (individual actions). `performj/3` from `jactions.pl`
is never used. Need a `transj/4` (or extend `trans/4`) that applies joint actions,
enabling multi-agent transition reasoning.

---

## 5. Extend argumentation to cover all values (args.pl)

The debug output (`res.dbg`) shows all arguments are justified only by `lifeH`.
`freedomH`, `lifeC`, and `freedomC` never appear. Either:
- the initial states being explored don't trigger those values, or
- `arg/2` needs to enumerate arguments per-value more systematically.

Verify by querying `better(hal, S1, S2, freedomH)` and `lifeC` explicitly.

---

## 6. Implement argument defeat and reinstatement (args.pl)

`attacks/2` is defined but there is no:
- `defeats/2` (attack + relative strength)
- `acceptable/2` (Dung-style defence)
- `grounded_extension/1`, `preferred_extension/1`, or `stable_extension/1`

This is the core of the Bench-Capon practical reasoning framework and is entirely
missing. Minimum viable: implement the grounded semantics.

---

## 7. Add Carla's values and arguments

`values.pl` only defines `sub([...], hal)`. Carla has no value set, so no arguments
can be generated from her perspective. Add:
```prolog
sub([lifeC, freedomC], carla).
```
and verify `arg/2` works symmetrically for her.

---

## 8. Include `neut` in `eval/4` (values.pl)

`neutral/3` and `neut/4` are defined but `eval/4` only collects promoted and demoted
values, ignoring neutral ones. Either include them with `@Val` tagging or document
the intentional omission.

---

## 9. Write test queries in `dbg.pl`

The `@tbd` section in `dbg.pl` is empty. Add example queries covering:
- `state/1` enumeration
- `trans/4` step traces
- `arg/2` and `attacks/2` outputs
- `eval/4` for sample state pairs

---

## 10. Fix typo in `webapp/test.pl`

Line 13: `contais(fridge)` → `contains(fridge)`.

---

## 11. Connect webapp to the reasoning system

`webapp/test.pl` is a standalone HTTP skeleton with no link to the AATS modules.
Once the core argumentation is stable, expose endpoints such as:
- `GET /args` — list all current arguments
- `GET /attacks` — list attack relations
- `GET /extensions` — return grounded/preferred extensions
