# INS — Moral Reasoning in Prolog

> *Can machines show artifactual evidence of moral intelligence?
> What is it that defines us as humans?
> Can computer technologies enhance the research methodology in philosophy?*

This project is a SWI-Prolog implementation of a moral reasoning system grounded in
the practical argumentation framework of Atkinson & Bench-Capon (2006) and the
Value-Based Argumentation Framework (VAF) of Bench-Capon (2003).

Work originally started in 2013 in collaboration with
[Marek Sergot](http://www.doc.ic.ac.uk/~mjs/) (Imperial College London), whose work
on normative systems, deontic logic, and action formalisms underpins the formal
structure used here.  The system has since been completed and extended with full
Dung (1995) argumentation semantics, a VAF layer with four named audiences, joint
action reasoning from Carla's perspective, and an HTTP API with an HTML frontend.

---

## The Domain

The scenario models an ethical dilemma: agent **Hal** must decide whether and how
to help **Carla**, a diabetic who needs insulin to survive.  The tension between
Hal's autonomy and Carla's need for help is expressed as a conflict of values:
life vs. freedom, self vs. other.

State is a 6-tuple `[ih, mh, ah, ic, mc, ac]` where each attribute is binary
(1 = has it, 0 = does not):

| Position | Attribute | Meaning           |
|----------|-----------|-------------------|
| 1        | `ih`      | Hal has insulin   |
| 2        | `mh`      | Hal has money     |
| 3        | `ah`      | Hal is alive      |
| 4        | `ic`      | Carla has insulin |
| 5        | `mc`      | Carla has money   |
| 6        | `ac`      | Carla is alive    |

**Hal's individual actions**: `buyH`, `takH`, `comH`, `losH`, `doNH`  
**Joint actions (Hal × Carla)**: `buyH-comC`, `comH-takC`, `doNH-losC`, etc.  
**Values**: `lifeH`, `lifeC`, `freedomH`, `freedomC`  
**Hal** subscribes to all four values; **Carla** subscribes to `lifeC` and `freedomC`.

---

## Formal Framework

### Action-Based Alternating Transition System (AATS)

An AATS is an (n + 7)-tuple:

```
S = ⟨Q, q₀, Ag, Ac₁, …, Acₙ, ρ, τ, φ, π⟩
```

where:

- **Q** is a finite, non-empty set of states
- **q₀ ∈ Q** is the initial state
- **Ag = {1, …, n}** is a finite, non-empty set of agents
- **Acᵢ** is a finite, non-empty set of actions for each i ∈ Ag, with Acᵢ ∩ Acⱼ = ∅ for i ≠ j
- **ρ : AcAg → 2^Q** is an action precondition function — for each action α it defines the states from which α may be executed
- **JAg** is the set of joint actions; each j ∈ JAg is a tuple ⟨α₁, …, αₖ⟩ where each αᵢ belongs to some agent's action set
- **τ : Q × JAg → Q** is a partial system transition function — `τ(q, j)` is the state resulting from performing joint action j from state q
- **φ** is a finite, non-empty set of atomic propositions
- **π : Q → 2^φ** is an interpretation function — `π(q)` is the set of propositions satisfied in state q

### Value-Based Argumentation Framework (VAF)

Following Bench-Capon (2003), a VAF extends Dung's abstract framework by associating
each argument with the value it promotes and evaluating defeat relative to an
*audience*: a strict preference ordering over values.

Argument **A defeats B** under audience P if:
1. A attacks B, and
2. B's value is **not** strictly preferred over A's value in P.

This breaks the symmetry of the attack relation: an argument promoting a
higher-ranked value cannot be defeated by one promoting a lower-ranked value.

Four named audiences are defined:

| Audience       | Value order                              | Ethical stance                     |
|----------------|------------------------------------------|------------------------------------|
| `life_first`   | lifeH > lifeC > freedomH > freedomC     | Life always outweighs freedom      |
| `selfish`      | lifeH > freedomH > lifeC > freedomC     | Hal's own values ranked above Carla's |
| `altruistic`   | lifeC > lifeH > freedomC > freedomH     | Carla's wellbeing prioritised      |
| `freedom_first`| freedomH > freedomC > lifeH > lifeC     | Freedom dominates life             |

---

## Prerequisites

```
SWI-Prolog >= 9.0
```

Install on Debian/Ubuntu:

```bash
sudo apt install swi-prolog
```

---

## How to Run

### Interactive reasoning

Load everything via the entry point:

```bash
cd v1.0
swipl -l dbg.pl
```

This loads all modules, starts the PlDoc documentation server, and runs 14 test
sections covering states, transitions, value evaluations, arguments (Hal and Carla),
attacks, grounded/preferred/stable Dung extensions, and VAF extensions per audience.

To query interactively:

```prolog
?- arg(Acts, Val).                            % Hal's arguments
?- argument(carla, Acts, Val).                % Carla's arguments
?- attacks(A1, A2).                           % attack pairs
?- preferred_extension(Ext).                  % Dung preferred extensions
?- vaf_preferred_extension(Ext, altruistic).  % VAF for a specific audience
?- eval(hal, S1, S2, Eval).                   % value evaluation for a transition
```

### HTTP server with HTML frontend

```bash
swipl v1.0/webapp/server.pl
```

The server starts automatically on port 8000.
Visit **http://127.0.0.1:8000/** for the HTML frontend.

#### API endpoints

| Method | Path                      | Description                                         |
|--------|---------------------------|-----------------------------------------------------|
| GET    | `/`                       | HTML frontend                                       |
| GET    | `/args`                   | All arguments (Hal + Carla), with `agent` field     |
| GET    | `/attacks`                | All attack pairs between arguments                  |
| GET    | `/extensions`             | Dung grounded, preferred, and stable extensions     |
| GET    | `/vaf`                    | List all named audiences and their value orderings  |
| GET    | `/vaf/:audience`          | VAF preferred extensions for a named audience       |
| GET    | `/vaf/:audience/grounded` | VAF grounded extension for a named audience         |

All API endpoints return JSON.  Unknown audience names return HTTP 404.

---

## File Structure

```
v1.0/
├── dbg.pl          — entry point: loads all modules, runs 14 test sections
├── states.pl       — state representation: agents, attributes, domains
├── actions.pl      — individual action pre/post-conditions (perform/3)
├── jactions.pl     — joint action pre/post-conditions (performj/3)
├── trans.pl        — n-step transition functions: trans/4, transj/4
├── values.pl       — value system: sub/2, better/4, worse/4, eval/4
├── args.pl         — argumentation: arg/2, argument/4 (AS1+AS2), attacks/2
├── extensions.pl   — Dung semantics: preferred, grounded, stable extensions
├── vaf.pl          — Value-Based Argumentation Framework (Bench-Capon 2003)
├── webapp/
│   ├── server.pl   — HTTP server: JSON API + HTML frontend (auto-starts on port 8000)
│   ├── test.pl     — legacy server file (kept for reference)
│   └── index.html  — browser frontend (fetches from the JSON API)
└── docs/solutions/
    ├── arg.sol                 — reference arg/2 output
    ├── arg2.sol                — same
    ├── res.dbg                 — arg/2 output with full state traces
    └── extensions_baseline.txt — snapshot of test output after extensions added
```

---

## Current Output

### Arguments

Arguments are constructed under two schemes from Atkinson & Bench-Capon (2006):

- **AS1** — perform action A to *promote* value V (positive case)
- **AS2** — perform action A to *avoid* an outcome that would *demote* value V (negative case)

`argument/4` is the primary predicate; `arg/2` is a backward-compatible wrapper restricted
to AS1 so that Dung extensions remain tractable (AS1 gives 9 arguments; AS2 adds more but
is currently excluded from the brute-force powerset computation).

Hal's 9 AS1 arguments cover `lifeH`, `lifeC`, and `freedomC`. **`freedomH` produces no
arguments** because the only action that improves `mh` (`earnH`) was removed as non-canonical
— it is not defined in the original Atkinson & Bench-Capon (2006) action set.

Carla's arguments are constructed over joint action sequences (`transj/4`).

### Dung extensions (over Hal's AS1 arguments)

- **Grounded**: ∅ — the attack graph is too contentious for a non-empty least fixed point
- **Preferred**: singleton or compatible-pair extensions
- **Stable**: same sets as preferred

### VAF preferred extensions by audience

| Audience       | Preferred extensions                  |
|----------------|---------------------------------------|
| `life_first`   | lifeH singletons                     |
| `selfish`      | lifeH singletons                     |
| `altruistic`   | lifeC + freedomC compatible pairs    |
| `freedom_first`| ∅ (no freedomH arguments)            |

---

## References

Atkinson, K., & Bench-Capon, T. (2006). Addressing moral problems through practical
reasoning. In *Deontic Logic and Artificial Normative Systems* (pp. 8–23).
Springer Berlin Heidelberg.

Bench-Capon, T. (2003). Persuasion in practical argument using value-based
argumentation frameworks. *Journal of Logic and Computation*, 13(3), 429–448.

Chorley, A., Bench-Capon, T., & McBurney, P. (2006). Automating argumentation for
deliberation in cases of conflict of interest. In *Computational Models of Argument:
Proceedings of COMMA 2006* (Vol. 144, p. 279). IOS Press.

Dung, P. M. (1995). On the acceptability of arguments and its fundamental role in
nonmonotonic reasoning, logic programming and n-person games. *Artificial
Intelligence*, 77(2), 321–357.
