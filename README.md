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
action reasoning from Carla's perspective, dialectical proof via the φ₁-proof theory
of Cayrol, Doutre & Mengin (2003), and an HTTP API with an HTML frontend.

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
| `life_first`   | lifeH > lifeC > freedomH > freedomC     | Life always outweighs freedom; lifeH singletons |
| `selfish`      | lifeH > freedomH > lifeC > freedomC     | Hal's values above Carla's; lifeH singletons    |
| `altruistic`   | lifeC > lifeH > freedomC > freedomH     | Carla prioritised; lifeC+freedomC pairs         |
| `freedom_first`| freedomH > freedomC > lifeH > lifeC     | Freedom dominates; lifeC+freedomC pairs         |

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

This loads all modules, starts the PlDoc documentation server, and runs 18 test
sections covering states, transitions, value evaluations, arguments (Hal and Carla,
both AS1 and AS2), attacks, grounded/preferred/stable Dung extensions, VAF extensions
per audience, and dialectical proofs (credulous/sceptical acceptance).

To query interactively:

```prolog
?- arg(Acts, Val).                                    % Hal's AS1+AS2 arguments (35)
?- argument(carla, Acts, Val, Scheme).                % Carla's arguments (joint actions)
?- attacks(A1, A2).                                   % attack pairs
?- preferred_extension(Ext).                          % Dung preferred extensions (13)
?- vaf_preferred_extension(Ext, altruistic).          % VAF for a specific audience
?- credQA(arg([buyH,doNH], lifeH), (Seq, Pro)).       % φ₁ dialectical proof
?- vaf_credQA(arg([comH,doNH], lifeC), altruistic, Proof). % VAF credulous acceptance
?- sceptically_accepted(Arg).                         % sceptical acceptance (none)
?- eval(hal, S1, S2, Eval).                           % value evaluation for a transition
```

### HTTP server with HTML frontend

```bash
swipl v1.0/webapp/server.pl
```

The server starts automatically on port 8000.
Visit **http://127.0.0.1:8000/** for the HTML frontend.

#### API endpoints

| Method | Path                           | Description                                         |
|--------|--------------------------------|-----------------------------------------------------|
| GET    | `/`                            | HTML frontend                                       |
| GET    | `/args`                        | All arguments (Hal + Carla), with `agent` field     |
| GET    | `/attacks`                     | All attack pairs between arguments                  |
| GET    | `/extensions`                  | Dung grounded, preferred, and stable extensions     |
| GET    | `/vaf`                         | List all named audiences and their value orderings  |
| GET    | `/vaf/:audience`               | VAF preferred extensions for a named audience       |
| GET    | `/vaf/:audience/grounded`      | VAF grounded extension for a named audience         |
| GET    | `/credulous`                   | All credulously accepted arguments with φ₁ proofs   |
| GET    | `/credulous/sceptical`         | All sceptically accepted arguments                  |
| GET    | `/credulous/vaf/:audience`     | VAF credulous acceptance for a named audience       |

All API endpoints return JSON.  Unknown audience names return HTTP 404.

---

## File Structure

```
v1.0/
├── dbg.pl          — entry point: loads all modules, runs 18 test sections
├── states.pl       — state representation: agents, attributes, domains
├── actions.pl      — individual action pre/post-conditions (perform/3)
├── jactions.pl     — joint action pre/post-conditions (performj/3)
├── trans.pl        — n-step transition functions: trans/4, transj/4
├── values.pl       — value system: sub/2, better/4, worse/4, eval/4
├── args.pl         — argumentation: arg/2, argument/4 (AS1+AS2), attacks/2
├── extensions.pl   — Dung semantics: preferred, grounded, stable (Caminada labelling)
├── vaf.pl          — Value-Based Argumentation Framework (Bench-Capon 2003)
├── credulous.pl    — φ₁-proof / credulous & sceptical acceptance (CDM 2003)
├── webapp/
│   ├── server.pl   — HTTP server: JSON API + HTML frontend (auto-starts on port 8000)
│   ├── test.pl     — legacy server file (kept for reference)
│   └── index.html  — browser frontend (fetches from the JSON API)
docs/
├── notes/
│   ├── framing_problem.md              — freedomH gap as case study (item 15)
│   ├── as2_in_extensions.md            — AS2 inclusion: problem, solution, results (item 17)
│   └── credulous_sceptical_acceptance.md — dialectical proof: results and interpretation (item 18)
└── solutions/
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

`argument/4` generates both schemes; `arg/2` includes all of Hal's arguments (AS1 + AS2),
giving **35 arguments** in total. Carla's arguments are constructed over joint action
sequences (`transj/4`) and accessed via `argument(carla, ...)`.

**`freedomH` produces no AS1 arguments** because no canonical action in the Atkinson &
Bench-Capon (2006) action set positively promotes `mh`. AS2 arguments for `freedomH` do
exist (defending against demotion), but there is no forward-looking case for financial
freedom. This is kept open as a deliberate case study in the frame problem — see
`docs/notes/framing_problem.md`.

### Dung extensions (over 35 AS1+AS2 arguments)

- **Grounded**: `[]` — the attack graph is maximally contentious; no argument is unassailable
- **Preferred**: 13 extensions
- **Stable**: subset of preferred

### VAF preferred extensions by audience (AS1+AS2)

| Audience       | Value order                              | Preferred extensions |
|----------------|------------------------------------------|----------------------|
| `life_first`   | lifeH > lifeC > freedomH > freedomC     | 10                   |
| `selfish`      | lifeH > freedomH > lifeC > freedomC     | 10                   |
| `altruistic`   | lifeC > lifeH > freedomC > freedomH     | 10                   |
| `freedom_first`| freedomH > freedomC > lifeH > lifeC     | 6                    |

`freedom_first` gives 6 (not 10): AS2 `freedomH` arguments participate under this audience
but only defensively — no AS1 `freedomH` arguments exist (framing problem, item 15).

### Credulous and sceptical acceptance

| Query                   | Result      | Interpretation                            |
|-------------------------|-------------|-------------------------------------------|
| Credulously accepted    | 35 / 35     | Every argument appears in some preferred extension |
| Sceptically accepted    | 0 / 35      | No argument is in every preferred extension        |

The framework is **maximally contentious**: every argument can be defended (nothing is
indefensible) and every argument can be challenged (nothing is unassailable). This is
consistent with the empty grounded extension — a known result from Dung (1995).

Credulous acceptance is witnessed by a **φ₁-proof**: a structured dialogue in which a
PROponent defends the argument against all OPPonent challenges. Some arguments are
self-defending (one-move proof — OPP has no legal reply); others require a chain of
supporting moves. The proof structure encodes the dialectical complexity of the argument.
See `docs/notes/credulous_sceptical_acceptance.md` for the full interpretation.

---

## References

Atkinson, K., & Bench-Capon, T. (2006). Addressing moral problems through practical
reasoning. In *Deontic Logic and Artificial Normative Systems* (pp. 8–23).
Springer Berlin Heidelberg.

Bench-Capon, T. (2003). Persuasion in practical argument using value-based
argumentation frameworks. *Journal of Logic and Computation*, 13(3), 429–448.

Caminada, M. (2006). On the issue of reinstatement in argumentation. In *Logics in
Artificial Intelligence: JELIA 2006*, LNCS 4160, pp. 111–123. Springer.

Cayrol, C., Doutre, S., & Mengin, J. (2003). On decision problems related to the
preferred semantics for argumentation frameworks. *Journal of Logic and Computation*,
13(3), 377–402.

Chorley, A., Bench-Capon, T., & McBurney, P. (2006). Automating argumentation for
deliberation in cases of conflict of interest. In *Computational Models of Argument:
Proceedings of COMMA 2006* (Vol. 144, p. 279). IOS Press.

Dung, P. M. (1995). On the acceptability of arguments and its fundamental role in
nonmonotonic reasoning, logic programming and n-person games. *Artificial
Intelligence*, 77(2), 321–357.
