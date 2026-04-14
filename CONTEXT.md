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

Two argument schemes from Atkinson & Bench-Capon (2006) are implemented:

- **AS1** — In circumstances R, perform A, leading to S, realising G, promoting value V.
- **AS2** — In circumstances R, perform A, to avoid S, which would demote value V.

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

### Test suite

```bash
swipl -l v1.0/dbg.pl
```

Loads all modules, starts PlDoc, runs all test sections, prints to stdout, halts.

### HTTP server

```bash
swipl v1.0/webapp/server.pl
```

Starts automatically on port 8000. Visit http://127.0.0.1:8000/.

### Interactive

```bash
swipl
?- [v1.0/dbg].
?- arg(Acts, Val).                            % Hal's AS1 arguments
?- argument(hal, Acts, Val, Scheme).          % all arguments with scheme tag
?- argument(carla, Acts, Val, Scheme).        % Carla's arguments (joint actions)
?- attacks(A1, A2).
?- vaf_preferred_extension(Ext, altruistic).
?- initial_state(S), trans(S, Acts, Next, 2), eval(hal, S, Next, E).
```

---

## File structure

```
v1.0/
├── dbg.pl          — entry point: loads all modules, runs test sections
├── states.pl       — state representation: agents, attributes, domains
├── actions.pl      — individual action pre/post-conditions (perform/3)
├── jactions.pl     — joint action pre/post-conditions (performj/3)
├── trans.pl        — trans/4 (individual) and transj/4 (joint) transitions
├── values.pl       — sub/2, better/4, worse/4, neut/4, eval/4
├── args.pl         — argument/4 (AS1+AS2), arg/2 (AS1 wrapper), attacks/2
├── extensions.pl   — Dung semantics: preferred, grounded, stable extensions
├── vaf.pl          — Value-Based Argumentation Framework (Bench-Capon 2003)
├── webapp/
│   ├── server.pl   — HTTP server: JSON API + HTML frontend (auto-starts port 8000)
│   ├── test.pl     — legacy server file (kept for reference)
│   └── index.html  — browser frontend
└── docs/solutions/
    ├── arg.sol                 — reference arg/2 output (pre-fix)
    ├── arg2.sol                — same
    ├── res.dbg                 — arg/2 output with full state traces
    └── extensions_baseline.txt — snapshot after Dung extensions added
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

**Initial states** (across 3 active scenarios — freedomH scenario removed with earnH):

| Pattern          | Crisis                | Value targeted |
|------------------|-----------------------|----------------|
| `[0,_,1,1,_,1]` | Hal lacks insulin     | lifeH          |
| `[1,1,1,0,_,1]` | Carla lacks insulin   | lifeC          |
| `[1,1,1,1,0,1]` | Carla lacks money     | freedomC       |

**Hal's individual actions**: `buyH`, `takH`, `comH`, `losH`, `doNH`
(`earnH` was removed — not defined in Atkinson & Bench-Capon 2006)
**Hal's joint actions with Carla**: `buyH-comC`, `comH-takC`, `doNH-losC`, etc.
**Values**: `lifeH`, `lifeC`, `freedomH`, `freedomC`
**Hal** subscribes to all four; **Carla** subscribes to `lifeC` and `freedomC`.

---

## Current output

### AS1 arguments (9 total — `freedomH` has none)

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

`freedomH` produces no arguments because `earnH` (the only action improving `mh`)
was removed as non-canonical. This is an open design question.

### AS2 arguments

Generated via `argument(hal, Acts, Val, as2)`. These argue *against* actions by showing
they would demote a value. Currently excluded from `arg/2`, so they do not participate
in Dung extensions or the attack relation (kept tractable: O(2^9) instead of O(2^n)).

### Dung extensions (over AS1 arguments)

- **Grounded**: `[]`
- **Preferred**: singleton or compatible-pair extensions
- **Stable**: same sets

### VAF preferred extensions by audience

| Audience       | Value order                         | Preferred extensions              |
|----------------|-------------------------------------|-----------------------------------|
| `life_first`   | lifeH > lifeC > freedomH > freedomC | lifeH singletons                 |
| `selfish`      | lifeH > freedomH > lifeC > freedomC | lifeH singletons                 |
| `altruistic`   | lifeC > lifeH > freedomC > freedomH | lifeC + freedomC pairs           |
| `freedom_first`| freedomH > freedomC > lifeH > lifeC | ∅ (no freedomH arguments)        |

---

## Commit history

| Commit     | Change |
|------------|--------|
| `e938a86`  | Added `TODO.md` |
| `d8b2a2d`  | Fixed `values.pl:neutral/4` syntax error |
| `9f958ca`  | Fixed `arg/2` deduplication via `setof` |
| `d16b2fc`  | Added `CONTEXT.md` |
| `0eb9123`  | Saved `extensions_baseline.txt` |
| `1d94f82`  | Added `extensions.pl`: Dung preferred/grounded/stable |
| `16cdab3`  | Added `vaf.pl`: VAF with 4 audiences |
| `ac73d8b`  | Added lifeC/freedomH/freedomC args; `earnH`; performance fix |
| `66ada53`  | Fixed export warnings; `demotes/4` agent bug; `doNH-losC` duplicate |
| `d554c54`  | Removed non-canonical `earnH`; removed freedomH initial state |
| `dec247f`  | Added AS2 scheme; `argument/4` with `as1`/`as2` tag |
| `0c4e80c`  | Exposed `scheme` field in `/args` API |
| `ffed1c2`  | Clarified `arg_json/4` compatibility clause |
| `279a3eb`  | Scheme-aware connector label in plain-English mode |
| `820e56d`  | Updated `dbg.pl` to use `argument/4` and show AS2 |
| `58d0409`  | Passed scheme to argInline for extensions/VAF panels |
| `fb184dd`  | Restricted `arg/2` to AS1 only (extensions tractability) |
| `(current)`| Added `initialization` directive to `server.pl` — now auto-starts |

---

## Open questions / next steps

1. **`freedomH` coverage** — no canonical action promotes `mh`. Is this intentional
   (Hal simply cannot argue for his financial freedom in this domain) or should a new
   action be introduced from the literature?

2. **AS2 in extensions** — AS2 arguments are built but excluded from `arg/2` and
   therefore from Dung extensions and VAF. Integrating them would require either
   a smarter extension algorithm (not brute-force powerset) or a deliberate scope decision.

3. **Carla's AS2 arguments** — currently only AS1 is checked for Carla
   (`argument(carla, Acts, Val, as1)`). AS2 for joint actions not yet verified.
