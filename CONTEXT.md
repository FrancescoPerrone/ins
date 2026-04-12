# Project Context

## What this is

A SWI-Prolog implementation of a moral reasoning system grounded in the
Atkinson & Bench-Capon (2006) practical reasoning / argumentation framework.
The system models an ethical dilemma: agent **Hal** must decide whether and
how to help **Carla**, a diabetic who needs insulin.

The formal backbone is an **Action-based Alternating Transition System (AATS)**
where states, actions, values, and arguments are all represented in Prolog.
Arguments are evaluated using **Dung (1995) abstract argumentation semantics**
(conflict-free, admissible, preferred, grounded, stable extensions) and
**Value-Based Argumentation Framework (VAF)** from Bench-Capon (2003), where
different audience orderings over values produce different preferred extensions.

Key references:
> Atkinson, K., & Bench-Capon, T. (2006). Addressing moral problems through
> practical reasoning. *Deontic Logic and Artificial Normative Systems*, pp. 8–23.

> Bench-Capon, T. (2003). Persuasion in practical argument using value-based
> argumentation frameworks. *Journal of Logic and Computation*, 13(3), 429–448.

---

## Prerequisites

```
SWI-Prolog >= 9.0  (tested on 9.0.4)
```

Install on Debian/Ubuntu:
```bash
sudo apt install swi-prolog
```

---

## How to run

Load everything via the entry point:

```bash
swipl -l v1.0/dbg.pl
```

This loads all modules, starts the PlDoc documentation server, runs all test
queries, and prints results to stdout. The system then halts automatically.

To use interactively instead:

```bash
swipl
?- [v1.0/dbg].
?- arg(Acts, Val).
?- attacks(A1, A2).
?- vaf_preferred_extension(Ext, life_first).
?- initial_state(S), trans(S, Acts, Next, 2), eval(hal, S, Next, E).
```

---

## File structure

```
v1.0/
├── dbg.pl          — entry point: loads all modules, runs test queries 1–11
├── states.pl       — state representation: agents, attributes, domains
├── actions.pl      — individual action pre/post-conditions (perform/3)
├── jactions.pl     — joint action pre/post-conditions (performj/3)
├── trans.pl        — n-step transition function; defines initial states
├── values.pl       — value system: better/4, worse/4, eval/4
├── args.pl         — argumentation: arg/2, attacks/2
├── extensions.pl   — Dung semantics: preferred, grounded, stable extensions
├── vaf.pl          — Value-Based Argumentation Framework (Bench-Capon 2003)
├── webapp/
│   └── test.pl     — HTTP server skeleton (disconnected from reasoning)
└── docs/solutions/
    ├── arg.sol                 — expected arg/2 output (pre-fix reference)
    ├── arg2.sol                — same
    ├── res.dbg                 — expected arg/2 output with full state traces
    └── extensions_baseline.txt — snapshot of test output after extensions added
```

---

## Domain

State is a 6-tuple `[ih, mh, ah, ic, mc, ac]` where each attribute is binary
(1 = has it, 0 = doesn't):

| Position | Attribute | Meaning            |
|----------|-----------|--------------------|
| 1        | ih        | Hal has insulin    |
| 2        | mh        | Hal has money      |
| 3        | ah        | Hal is alive       |
| 4        | ic        | Carla has insulin  |
| 5        | mc        | Carla has money    |
| 6        | ac        | Carla is alive     |

**Initial states** (8 total, across 4 scenarios):

| Pattern            | Crisis         | Value targeted |
|--------------------|----------------|----------------|
| `[0,_,1,1,_,1]`   | Hal lacks insulin | lifeH       |
| `[1,1,1,0,_,1]`   | Carla lacks insulin | lifeC     |
| `[1,0,1,1,_,1]`   | Hal lacks money | freedomH      |
| `[1,1,1,1,0,1]`   | Carla lacks money | freedomC    |

**Hal's individual actions**: `buyH`, `takH`, `comH`, `losH`, `doNH`
**Hal's joint actions with Carla**: `buyH-comC`, `comH-takC`, `doNH-losC`, etc.
**Values** (Hal subscribes to all): `lifeH`, `lifeC`, `freedomH`, `freedomC`

---

## Current output (as of last commit)

### Arguments (9 total; freedomH has no arguments — earnH removed as non-canonical)

```
arg([buyH,doNH],  lifeH)
arg([takH,comH],  lifeH)
arg([takH,doNH],  lifeH)

arg([comH,doNH],  lifeC)
arg([comH,losH],  lifeC)
arg([doNH,comH],  lifeC)

arg([comH,doNH],  freedomC)
arg([comH,losH],  freedomC)
arg([doNH,comH],  freedomC)
```

### Dung extensions

- **Grounded**: `[]` (empty — attack graph is too contentious for a non-empty least fixed point)
- **Preferred**: 12 singleton/pair extensions, one per "winning" argument or compatible pair
- **Stable**: same 12 sets (all preferred are also stable)

### VAF preferred extensions by audience

| Audience       | Value order                         | Preferred extensions         |
|----------------|-------------------------------------|------------------------------|
| `life_first`   | lifeH > lifeC > freedomH > freedomC | 4 × lifeH singletons         |
| `selfish`      | lifeH > freedomH > lifeC > freedomC | 4 × lifeH singletons         |
| `altruistic`   | lifeC > lifeH > freedomC > freedomH | lifeC+freedomC pairs (×4)    |
| `freedom_first`| freedomH > freedomC > lifeH > lifeC | 3 × freedomH singletons      |

---

## What has been fixed (all sessions)

| Commit     | Fix |
|------------|-----|
| `e938a86`  | Added `TODO.md` with prioritized gap analysis |
| `d8b2a2d`  | Fixed syntax error in `values.pl:neutral/4` — `@Val` → `@(Val)` |
| `9f958ca`  | Fixed `arg/2`: replaced broken `not(not(...))` with `setof`-based deduplication; `Val` now ground |
| `d16b2fc`  | Added `CONTEXT.md` |
| `0eb9123`  | Saved `docs/solutions/extensions_baseline.txt` |
| `1d94f82`  | Added `extensions.pl`: Dung preferred/grounded/stable semantics |
| `16cdab3`  | Added `vaf.pl`: VAF with 4 audiences, defeat relation, preferred/grounded extensions |
| `ac73d8b`  | Added `lifeC`, `freedomH`, `freedomC` arguments; new initial states + `earnH` action; fixed preferred extension performance (linear maximality check) |
| (current)  | Removed non-canonical `earnH` action — not defined in Atkinson & Bench-Capon (2006); `freedomH` now produces no arguments |
| `66ada53`  | Fixed `extensions.pl` export warnings; fixed `demotes/4` hardcoded `hal` → `Ag`; removed duplicate `doNH-losC` clause in `jactions.pl` |

---

## What needs to be done next

See `TODO.md` for full detail. Top remaining items:

1. **Wire `performj/3` into `trans.pl`** — joint actions are defined but never used in transitions
2. **Add Carla's value subscription** — `sub([lifeC, freedomC], carla)` missing from `values.pl`
3. **Include `neut` in `eval/4`** — neutral values are computed but excluded from evaluation output
4. **Connect `webapp/test.pl` to the reasoning system** — HTTP skeleton is disconnected
