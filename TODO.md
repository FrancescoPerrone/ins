# TODO — Implementation Gaps (Priority Order)

---

## ~~1. Fix `arg/2` duplicate results (args.pl)~~ — DONE

Fixed via `setof/3` deduplication. Each `(Acts, Val)` pair is now produced exactly once.

---

## ~~2. Fix `doNH-losC` duplicate clauses (jactions.pl)~~ — DONE

Removed duplicate clause at line 52 (was identical to line 47).

---

## ~~3. Fix `demotes/4` hardcoded agent (values.pl)~~ — DONE

Changed `worse(hal, ...)` to `worse(Ag, ...)` so `eval/4` works correctly for any agent.

---

## ~~4. Extend argumentation to cover all values (args.pl)~~ — DONE

Added 3 new initial state patterns to `trans.pl` (for lifeC, freedomH, freedomC scenarios)
and a new `earnH` action to `actions.pl`. All 4 values now produce arguments.

---

## ~~5. Implement argument defeat and extensions (args.pl)~~ — DONE

`extensions.pl` implements full Dung (1995) semantics: conflict-free, admissible,
preferred, grounded, and stable extensions.
`vaf.pl` implements the Value-Based Argumentation Framework with 4 audiences.

---

## ~~6. Fix export warnings (extensions.pl)~~ — DONE

Exported `powerset/2` and `is_subset/2` so `vaf.pl` can import them without warnings.

---

## 7. Wire joint actions into `trans.pl` — MISSING FEATURE

`trans.pl` only calls `perform/3` (individual actions). `performj/3` from `jactions.pl`
is never used. Need a `transj/4` (or extend `trans/4`) that applies joint actions,
enabling multi-agent transition reasoning and arguments from Carla's perspective.

---

## 8. Add Carla's value subscription (values.pl)

`values.pl` only defines `sub([lifeH, lifeC, freedomH, freedomC], hal)`.
Carla has no value set, so no arguments can be generated from her perspective. Add:

```prolog
sub([lifeC, freedomC], carla).
```

and verify `arg/2` works symmetrically for her once joint actions are wired in.

---

## 9. Include `neut` in `eval/4` (values.pl)

`neutral/3` and `neut/4` are defined but `eval/4` only collects promoted and demoted
values, ignoring neutral ones. Either include them with `@Val` tagging or document
the intentional omission.

---

## ~~10. Write test queries in `dbg.pl`~~ — DONE

`dbg.pl` now has 11 test sections covering states, transitions, value evaluations,
arguments, attacks, grounded/preferred/stable Dung extensions, and VAF extensions
per audience.

---

## 11. Fix typo in `webapp/test.pl`

Line 13: `contais(fridge)` → `contains(fridge)`.

---

## 12. Connect webapp to the reasoning system

`webapp/test.pl` is a standalone HTTP skeleton with no link to the AATS modules.
Once the core argumentation is stable, expose endpoints such as:
- `GET /args` — list all current arguments
- `GET /attacks` — list attack relations
- `GET /extensions` — return grounded/preferred extensions
- `GET /vaf/:audience` — return VAF preferred extensions for a named audience
