# Project Context

## What this is

A SWI-Prolog implementation of a moral reasoning system grounded in the
Atkinson & Bench-Capon (2006) practical reasoning / argumentation framework.
The system models an ethical dilemma: agent **Hal** must decide whether and
how to help **Carla**, a diabetic who needs insulin.

The formal backbone is an **Action-based Alternating Transition System (AATS)**
where states, actions, values, and arguments are all represented in Prolog.

Key reference:
> Atkinson, K., & Bench-Capon, T. (2006). Addressing moral problems through
> practical reasoning. *Deontic Logic and Artificial Normative Systems*, pp. 8–23.

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
?- initial_state(S), trans(S, Acts, Next, 2), eval(hal, S, Next, E).
```

---

## File structure

```
v1.0/
├── dbg.pl          — entry point: loads all modules, runs test queries
├── states.pl       — state representation: agents, attributes, domains
├── actions.pl      — individual action pre/post-conditions (perform/3)
├── jactions.pl     — joint action pre/post-conditions (performj/3)
├── trans.pl        — n-step transition function; defines initial states
├── values.pl       — value system: better/4, worse/4, eval/4
├── args.pl         — argumentation: arg/2, attacks/2
├── webapp/
│   └── test.pl     — HTTP server skeleton (disconnected from reasoning)
└── docs/solutions/
    ├── arg.sol     — expected arg/2 output (pre-fix reference)
    ├── arg2.sol    — same
    └── res.dbg     — expected arg/2 output with full state traces
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

**Initial states** (4 total): Hal lacks insulin (`ih=0`), is alive (`ah=1`),
Carla has insulin (`ic=1`), is alive (`ac=1`). Money varies.

**Hal's actions**: `buyH`, `takH`, `comH`, `losH`, `doNH`
**Values** (Hal subscribes to all): `lifeH`, `lifeC`, `freedomH`, `freedomC`

---

## Current output (as of last commit)

### Arguments

```
arg([buyH,doNH], lifeH)
arg([takH,comH], lifeH)
arg([takH,doNH], lifeH)
```

All three promote `lifeH` (give Hal insulin: `ih` goes 0→1).

### Attacks

```
arg([buyH,doNH],lifeH) attacks arg([takH,comH],lifeH)
arg([buyH,doNH],lifeH) attacks arg([takH,doNH],lifeH)
arg([takH,comH],lifeH) attacks arg([buyH,doNH],lifeH)
arg([takH,comH],lifeH) attacks arg([takH,doNH],lifeH)
arg([takH,doNH],lifeH) attacks arg([buyH,doNH],lifeH)
arg([takH,doNH],lifeH) attacks arg([takH,comH],lifeH)
```

Each argument attacks every other (all share value `lifeH`; current attack
criterion is simply `Acts \= ActsX`, with no value-based preference ordering).

---

## What has been fixed (recent session)

| Commit   | Fix |
|----------|-----|
| `e938a86` | Added `TODO.md` with prioritized gap analysis |
| `d8b2a2d` | Fixed syntax error in `values.pl:neutral/4` — `@Val` → `@(Val)` |
| `9f958ca` | Fixed `arg/2`: replaced broken `not(not(...))` with `better(hal, Init, NextX, Val)` (binds `Val`) and wrapped in `setof` to deduplicate across initial states |

---

## What needs to be done next (priority order)

See `TODO.md` for full detail. Top items:

1. **Fix `doNH-losC` duplicate clause in `jactions.pl`** (lines 47 and 52 identical)
2. **Fix `demotes/4` hardcoded `hal` in `values.pl`** (should use `Ag` variable)
3. **Wire `performj/3` into `trans.pl`** — joint actions are defined but never used
4. **Extend `arg/2` to cover all values** — currently only `lifeH` appears; need
   to verify/fix why `freedomH`, `lifeC`, `freedomC` never produce arguments
5. **Implement argument defeat and extensions** — `attacks/2` exists but there is
   no `defeats/2`, no acceptability check, no grounded/preferred/stable semantics
6. **Add Carla's value subscription** — `sub([...], carla)` missing from `values.pl`
7. **Write real test queries in `dbg.pl`** — `@tbd` section is still empty
8. **Connect `webapp/test.pl` to the reasoning system**
