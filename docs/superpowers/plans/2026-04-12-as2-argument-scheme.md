# AS2 Argument Scheme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the AS2 (negative) argument scheme from Atkinson & Bench-Capon (2006) so arguments that *protect* a value from demotion are generated alongside existing AS1 (positive) arguments, with a `scheme` tag distinguishing the two throughout the API and UI.

**Architecture:** `argument/4` replaces `argument/3` in `args.pl` as the primary predicate, adding a `Scheme` argument (`as1` or `as2`). The existing `arg/2` backward-compat wrapper is unchanged, so `attacks/2`, `extensions.pl`, and `vaf.pl` require no modifications. The scheme tag propagates through `server.pl` (added to JSON) and `index.html` (scheme-aware connector label in plain-English mode).

**Tech Stack:** SWI-Prolog ≥ 9.0, vanilla JS (no framework), HTTP via `library(http/thread_httpd)`.

---

## File map

| File | Change |
|------|--------|
| `v1.0/trans.pl` | Remove stale `initial_state([1,0,1,1,_,1])` |
| `v1.0/args.pl` | `argument/4` replaces `argument/3`; AS2 clauses added; `argument/3` kept as backward-compat wrapper; module export updated |
| `v1.0/webapp/server.pl` | `handle_args` uses `argument/4`; `arg_json/5` adds `scheme` field |
| `v1.0/webapp/index.html` | `arrowHtml(scheme)` becomes scheme-aware; `renderArgs` passes `a.scheme` |
| `v1.0/dbg.pl` | Query 14 updated to `argument/4`; new query 15 shows AS2 arguments |

---

## Task 1: Remove stale initial state

**Files:**
- Modify: `v1.0/trans.pl`

The state `[1,0,1,1,_,1]` (Hal has insulin but no money) was added only to make the removed `earnH` action work. With `mh=0`, neither AS1 nor AS2 can generate `freedomH` arguments from it.

- [ ] **Step 1: Verify the state is currently present**

```bash
grep -n "1,0,1,1" v1.0/trans.pl
```

Expected output: one line containing `initial_state([1,0,1,1,_,1]).`

- [ ] **Step 2: Remove the clause**

Open `v1.0/trans.pl`. The file currently contains four `initial_state/1` clauses. Remove this one:

```prolog
% Hal lacks money but has insulin (for freedomH)
initial_state([1,0,1,1,_,1]).
```

The remaining three clauses must be:

```prolog
% original: Hal lacks insulin, Carla has it
initial_state(Init):-
    Init = [0,_,1,1,_,1],
    state(Init).

% Carla lacks insulin; Hal has insulin and money and can give it (for lifeC)
initial_state(Init):-
    Init = [1,1,1,0,_,1],
    state(Init).

% Carla lacks money; Hal has everything and can compensate (for freedomC)
initial_state(Init):-
    Init = [1,1,1,1,0,1],
    state(Init).
```

- [ ] **Step 3: Verify the file loads cleanly**

```bash
cd v1.0 && swipl -l trans.pl -g "forall(initial_state(S), format('~w~n',[S])), halt"
```

Expected: three groups of initial states printed (no `[1,0,1,1,_,1]` pattern), no errors.

- [ ] **Step 4: Commit**

```bash
git add v1.0/trans.pl
git commit -m "remove stale freedomH initial state added for earnH"
```

---

## Task 2: Rewrite `args.pl` with `argument/4` and AS2 clauses

**Files:**
- Modify: `v1.0/args.pl`

This is the core logic change. Replace `argument/3` with `argument/4` (four clauses: AS1+AS2 for each of Hal and Carla). Keep `argument/3` and `arg/2` as backward-compat wrappers. Keep `attacks/2` unchanged.

- [ ] **Step 1: Verify current AS2 output is absent**

Run this query — it must currently produce **no output** (AS2 not yet implemented):

```bash
cd v1.0 && swipl -g "
  use_module(states), use_module(actions), use_module(jactions),
  use_module(trans), use_module(values), use_module(args),
  (argument(hal, Acts, Val, as2) -> format('as2: ~w ~w~n',[Acts,Val]) ; true),
  halt." 2>&1 | head -5
```

Expected: error `Unknown procedure: argument/4` or no `as2:` lines (confirms the predicate doesn't exist yet).

- [ ] **Step 2: Replace `args.pl` with the full updated content**

Write `v1.0/args.pl` with this exact content:

```prolog
:- module(args, [arg/2, argument/3, argument/4, attacks/2]).
:- use_module(library(pldoc)).

/** <module> Argument construction and attack relation.

Implements AS1 (positive) and AS2 (negative) argument schemes from
Atkinson & Bench-Capon (2006).

  AS1 — In circumstances R, perform A, leading to S, realising G,
         promoting value V.

  AS2 — In circumstances R, perform A, to avoid S, which would
         demote value V.

argument/4 is the primary predicate; argument/3 and arg/2 are
backward-compatible wrappers retained so attacks/2, extensions.pl,
and vaf.pl need no changes.

@author Francesco Perrone
@license GPL
*/


%% argument(+Ag, -Acts, -Val, -Scheme) is nondet
%
%  Constructs arguments for agent Ag.
%  Scheme is as1 (promotes Val) or as2 (protects Val from demotion).
%
%  Hal reasons over individual action sequences (trans/4).
%  Carla reasons over joint action sequences (transj/4).
%
%  AS1 and AS2 are mutually exclusive for a given (Init, Val):
%    AS1 fires when the value attribute is 0 in Init (improvement possible).
%    AS2 fires when the value attribute is 1 in Init (protection needed).
%
%  @arg Ag    Agent: hal or carla
%  @arg Acts  2-step action sequence
%  @arg Val   Value promoted or protected
%  @arg Scheme as1 or as2

% --- Hal AS1 ---
argument(hal, Acts, Val, as1) :-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     trans(Init, Acts, Next, 2),
                     better(hal, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

% --- Hal AS2 ---
argument(hal, Acts, Val, as2) :-
    setof(Acts-Val,
          Init^Next^Alt^(
              initial_state(Init),
              trans(Init, Acts, Next, 2),
              \+ worse(hal, Init, Next, Val),
              trans(Init, Alt, _, 2),
              worse(hal, Init, Alt, Val)
          ),
          Pairs),
    member(Acts-Val, Pairs).

% --- Carla AS1 ---
argument(carla, Acts, Val, as1) :-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     transj(Init, Acts, Next, 2),
                     better(carla, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).

% --- Carla AS2 ---
argument(carla, Acts, Val, as2) :-
    setof(Acts-Val,
          Init^Next^Alt^(
              initial_state(Init),
              transj(Init, Acts, Next, 2),
              \+ worse(carla, Init, Next, Val),
              transj(Init, Alt, _, 2),
              worse(carla, Init, Alt, Val)
          ),
          Pairs),
    member(Acts-Val, Pairs).


%% argument(+Ag, -Acts, -Val) is nondet
%
%  Backward-compatible wrapper: strips the scheme tag.
%  Retained so dbg.pl and other callers need minimal changes.
%
argument(Ag, Acts, Val) :- argument(Ag, Acts, Val, _).


%% arg(-Acts, -Val) is nondet
%
%  Backward-compatible wrapper: Hal's arguments (both schemes).
%  Used by attacks/2, extensions.pl, and vaf.pl — unchanged.
%
arg(Acts, Val) :- argument(hal, Acts, Val, _).


%% attacks(+A, +B) is nondet
%
%  Argument A attacks argument B when they advocate different action
%  sequences. The attack relation is symmetric and scheme-agnostic.
%
attacks(arg(Acts, V1), arg(ActsX, V2)) :-
    arg(Acts, V1),
    arg(ActsX, V2),
    Acts \= ActsX.
```

- [ ] **Step 3: Verify AS2 arguments are now generated**

```bash
cd v1.0 && swipl -g "
  use_module(states), use_module(actions), use_module(jactions),
  use_module(trans), use_module(values), use_module(args),
  forall(argument(hal, Acts, Val, as2),
         format('as2 hal: ~w -> ~w~n', [Acts, Val])),
  halt."
```

Expected: several lines of the form `as2 hal: [doNH,doNH] -> freedomH` (or similar). At least one `freedomH` argument must appear.

- [ ] **Step 4: Verify AS1 arguments still match previous output**

```bash
cd v1.0 && swipl -g "
  use_module(states), use_module(actions), use_module(jactions),
  use_module(trans), use_module(values), use_module(args),
  forall(argument(hal, Acts, Val, as1),
         format('as1 hal: ~w -> ~w~n', [Acts, Val])),
  halt."
```

Expected: the same AS1 arguments that existed before `earnH` was removed:
```
as1 hal: [buyH,doNH] -> lifeH
as1 hal: [takH,comH] -> lifeH
as1 hal: [takH,doNH] -> lifeH
as1 hal: [comH,doNH] -> lifeC
as1 hal: [comH,losH] -> lifeC
as1 hal: [doNH,comH] -> lifeC
as1 hal: [comH,doNH] -> freedomC
as1 hal: [comH,losH] -> freedomC
as1 hal: [doNH,comH] -> freedomC
```

(Exact set depends on initial states; the key check is no `earnH`-based arguments appear and no `freedomH` AS1 argument appears.)

- [ ] **Step 5: Verify backward-compat wrappers still work**

```bash
cd v1.0 && swipl -g "
  use_module(states), use_module(actions), use_module(jactions),
  use_module(trans), use_module(values), use_module(args),
  use_module(extensions), use_module(vaf),
  grounded_extension(G), format('grounded: ~w~n', [G]),
  halt."
```

Expected: loads without error; grounded extension printed (may be empty — that is correct).

- [ ] **Step 6: Commit**

```bash
git add v1.0/args.pl
git commit -m "add AS2 argument scheme; argument/4 with as1/as2 scheme tag"
```

---

## Task 3: Update `server.pl` to expose scheme in API

**Files:**
- Modify: `v1.0/webapp/server.pl`

`handle_args` must use `argument/4` and pass `Scheme` to a new `arg_json/5`.

- [ ] **Step 1: Verify current API response lacks scheme field**

Start the server (or use a one-shot query) and inspect `/args` output:

```bash
cd v1.0 && swipl -g "
  use_module(states), use_module(actions), use_module(jactions),
  use_module(trans), use_module(values), use_module(args),
  use_module(extensions), use_module(vaf),
  use_module(library(http/json)),
  argument(hal, Acts, Val, as1),
  !,
  format('value: ~w~n', [Val]),
  halt."
```

This just confirms the module loads. The scheme field absence is confirmed by reading the current `arg_json/4` signature.

- [ ] **Step 2: Update `handle_args` and add `arg_json/5`**

In `v1.0/webapp/server.pl`, replace:

```prolog
% GET /args
% All arguments for all agents.
% Hal uses individual action sequences; Carla uses joint action sequences.
% Each entry is {"agent": "...", "actions": [...], "value": "..."}.
handle_args(_Request) :-
    findall(J, (member(Ag, [hal, carla]),
                argument(Ag, Acts, Val),
                arg_json(Ag, Acts, Val, J)),
            Args),
    reply_json(Args).
```

with:

```prolog
% GET /args
% All arguments for all agents.
% Hal uses individual action sequences; Carla uses joint action sequences.
% Each entry is {"agent": "...", "actions": [...], "value": "...", "scheme": "as1"|"as2"}.
handle_args(_Request) :-
    findall(J, (member(Ag, [hal, carla]),
                argument(Ag, Acts, Val, Scheme),
                arg_json(Ag, Acts, Val, Scheme, J)),
            Args),
    reply_json(Args).
```

Then add `arg_json/5` immediately below the existing `arg_json/4` helper (keep `arg_json/4` for any other callers):

```prolog
% arg_json(+Ag, +Acts, +Val, +Scheme, -JSON)
arg_json(Ag, Acts, Val, Scheme, json([agent=Ag, actions=ActAtoms, value=Val, scheme=Scheme])) :-
    maplist(action_to_atom, Acts, ActAtoms).
```

- [ ] **Step 3: Verify the server loads and `/args` now includes scheme**

```bash
cd v1.0/webapp && swipl -g "
  [server],
  server(8001)" &
sleep 2
curl -s http://127.0.0.1:8001/args | python3 -m json.tool | grep scheme | head -5
kill %1
```

Expected: lines like `"scheme": "as1"` and `"scheme": "as2"` in the output.

- [ ] **Step 4: Commit**

```bash
git add v1.0/webapp/server.pl
git commit -m "expose scheme field in /args API response"
```

---

## Task 4: Update `index.html` for scheme-aware rendering

**Files:**
- Modify: `v1.0/webapp/index.html`

`arrowHtml()` gains an optional `scheme` parameter. Only `renderArgs` passes it — attacks, extensions, and VAF sections are unchanged.

- [ ] **Step 1: Update `arrowHtml` to accept scheme**

In `v1.0/webapp/index.html`, find and replace the existing `arrowHtml` function:

```javascript
function arrowHtml() {
  return MODE === 'english'
    ? '<span class="arr-label">promotes</span>'
    : '<span class="arr">→</span>';
}
```

Replace with:

```javascript
function arrowHtml(scheme) {
  if (MODE !== 'english') return '<span class="arr">→</span>';
  const label = scheme === 'as2' ? 'protects' : 'promotes';
  return `<span class="arr-label">${label}</span>`;
}
```

Callers that do not pass `scheme` (attacks, extensions, VAF) receive `undefined`, which evaluates `scheme === 'as2'` as `false` and correctly defaults to `'promotes'` — no changes needed there.

- [ ] **Step 2: Pass `a.scheme` in `renderArgs`**

In `renderArgs`, find the row template inside the `panel` function:

```javascript
const rows = list.map(a =>
  `<div class="arg-row">
     <span class="acts">${actsLabel(a)}</span>
     ${arrowHtml()}
     ${valChip(a.value)}
   </div>`
).join('');
```

Replace with:

```javascript
const rows = list.map(a =>
  `<div class="arg-row">
     <span class="acts">${actsLabel(a)}</span>
     ${arrowHtml(a.scheme)}
     ${valChip(a.value)}
   </div>`
).join('');
```

- [ ] **Step 3: Verify in browser**

Start the server and open the app:

```bash
cd v1.0/webapp && swipl -g "[server], server(8001)"
```

Open `http://127.0.0.1:8001` in a browser. Switch to **Plain English** mode. In the Arguments section:
- AS1 arguments must show the connector label **"promotes"**
- AS2 arguments must show the connector label **"protects"**

Switch back to **Code** mode — all connectors must show `→` regardless of scheme.

- [ ] **Step 4: Commit**

```bash
git add v1.0/webapp/index.html
git commit -m "scheme-aware connector label in plain-English mode (promotes / protects)"
```

---

## Task 5: Update `dbg.pl` to show scheme

**Files:**
- Modify: `v1.0/dbg.pl`

Two changes: update query 14 (Carla's arguments) to use `argument/4`, and add query 15 to enumerate all AS2 arguments.

- [ ] **Step 1: Update query 14**

In `v1.0/dbg.pl`, find:

```prolog
% 14. Carla's arguments (joint action sequences promoting her subscribed values)
:- format("~n--- Carla's arguments ---~n"),
   forall(argument(carla, Acts, Val),
          format("argument(carla, ~w, ~w)~n", [Acts, Val])).
```

Replace with:

```prolog
% 14. Carla's arguments (joint action sequences, both schemes)
:- format("~n--- Carla's arguments ---~n"),
   forall(argument(carla, Acts, Val, Scheme),
          format("argument(carla, ~w, ~w, ~w)~n", [Acts, Val, Scheme])).
```

- [ ] **Step 2: Add query 15 for AS2 arguments**

Immediately after query 14, add:

```prolog
% 15. All AS2 arguments (both agents)
:- format("~n--- AS2 arguments (both agents) ---~n"),
   forall((member(Ag, [hal, carla]), argument(Ag, Acts, Val, as2)),
          format("argument(~w, ~w, ~w, as2)~n", [Ag, Acts, Val])).
```

- [ ] **Step 3: Verify full debug run completes without errors**

```bash
cd v1.0 && swipl -l dbg.pl 2>&1 | tail -30
```

Expected: the final lines show AS2 arguments printed under `--- AS2 arguments (both agents) ---`, with at least one `freedomH` argument for Hal. No `ERROR` lines.

- [ ] **Step 4: Commit**

```bash
git add v1.0/dbg.pl
git commit -m "update dbg.pl queries to use argument/4 and show AS2 arguments"
```

---

## Self-review

**Spec coverage:**
- ✅ AS2 generation for Hal and Carla — Task 2
- ✅ `argument/4` with scheme tag — Task 2
- ✅ `arg/2` backward-compat wrapper unchanged — Task 2
- ✅ Remove `initial_state([1,0,1,1,_,1])` — Task 1
- ✅ `server.pl` scheme field in JSON — Task 3
- ✅ `index.html` scheme-aware connector label — Task 4
- ✅ `extensions.pl` / `vaf.pl` / `attacks/2` untouched — confirmed by no tasks for those files
- ✅ `dbg.pl` updated — Task 5

**Placeholder scan:** No TBDs, no "implement later", all code blocks are complete.

**Type consistency:**
- `argument/4` defined in Task 2; called in Task 3 (`server.pl`) and Task 4 (`dbg.pl`) — consistent arity and argument order throughout.
- `arg_json/5` defined and used only in Task 3 — consistent.
- `arrowHtml(scheme)` defined and called in Task 4 — consistent; undefined-scheme callers behave correctly.
