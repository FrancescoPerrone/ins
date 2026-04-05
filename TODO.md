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

## ~~7. Wire joint actions into `trans.pl`~~ — DONE

Added `transj/4` to `trans.pl` (mirrors `trans/4` using `performj/3`). Exported via
module declaration; `jactions` loaded via `use_module`. `dbg.pl` test section 12
confirms joint transitions fire correctly from all initial states.

---

## ~~8. Add Carla's value subscription (values.pl)~~ — DONE

Added `sub([lifeC, freedomC], carla).` to `values.pl`. `dbg.pl` test section 13
confirms `eval(carla, ...)` produces correct `[+lifeC]`/`[-freedomC]` evaluations
over joint transitions.

---

## ~~9. Include `neut` in `eval/4` (values.pl)~~ — DONE

Added `neutral(Ag, S1, S2, Val)` as a third disjunct in `eval/4`'s `setof`. Neutral
values appear as `@(Val)` in the result, visually distinct from `+Val`/`-Val`.
Comment above `eval/4` documents why they were originally omitted (no role in
argument construction or the Dung attack relation) and why they are now included
(completeness).

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
