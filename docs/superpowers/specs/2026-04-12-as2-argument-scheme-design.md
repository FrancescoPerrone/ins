# Design: AS2 Argument Scheme (Negative Arguments)

**Date**: 2026-04-12  
**Status**: Approved  
**References**: Atkinson & Bench-Capon (2006), §3 — AS1/AS2 argument schemes

---

## Problem

The framework currently only implements **AS1** (positive argument scheme): arguments that *promote* a value by improving an attribute from 0→1. This means `freedomH` — Hal's freedom, indexed by `mh` (having money) — cannot generate arguments, because the only action that could gain money (`earnH`) was non-canonical and has been removed. Freedom arguments in the paper are fundamentally about *protecting* existing resources, not acquiring new ones.

---

## Solution

Implement **AS2** (negative argument scheme): arguments that advocate an action sequence to *avoid* a state where a value would be demoted. Add a scheme tag (`as1` / `as2`) to the argument representation so the two schemes are distinguishable in the API and UI, while remaining equivalent in the argumentation layer.

---

## Architecture

### Argument representation

`argument/4` becomes the primary predicate in `args.pl`:

```prolog
argument(+Agent, -Acts, -Val, -Scheme)
```

Where `Scheme` is either `as1` or `as2`. The existing `arg/2` backward-compat wrapper remains unchanged:

```prolog
arg(Acts, Val) :- argument(hal, Acts, Val, _).
```

Because `arg/2` is unchanged, `attacks/2`, `extensions.pl`, and `vaf.pl` require **no modifications**. AS1 and AS2 arguments participate as equal, scheme-agnostic nodes in the argumentation graph.

### AS1 clause (unchanged logic, new arity)

```prolog
argument(hal, Acts, Val, as1) :-
    setof(Acts-Val,
          Init^Next^(initial_state(Init),
                     trans(Init, Acts, Next, 2),
                     better(hal, Init, Next, Val)),
          Pairs),
    member(Acts-Val, Pairs).
```

Same pattern for `carla` using `transj`.

### AS2 clause (new)

```prolog
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
```

The non-triviality condition (`trans(Init, Alt, _, 2), worse(hal, Init, Alt, Val)`) ensures the argument is meaningful: the value was genuinely at risk from an alternative action sequence available from the same initial state.

For `carla`, the same pattern applies using `transj` in place of `trans`:

```prolog
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
```

### Mutual exclusivity

AS1 and AS2 are mutually exclusive by construction for any given `(Init, Val)`:
- **AS1** fires when the value attribute is `0` in `Init` (`better/4` requires `attribute(At, Init, 0)`)
- **AS2** fires when the value attribute is `1` in `Init` (otherwise `worse` can never hold, so the non-triviality condition can never be satisfied)

The same `(Acts, Val)` pair cannot appear under both schemes from the same initial state.

---

## Initial state change

`trans.pl` currently defines:

```prolog
% Hal lacks money but has insulin (for freedomH)
initial_state([1,0,1,1,_,1]).
```

This state was added solely to make `earnH` work. With `mh=0`, neither AS1 (can't improve what you don't have) nor AS2 (can't protect what you don't have — `worse` requires 1→0) can generate `freedomH` arguments from it. It is removed.

Existing initial states already provide the right context for AS2 `freedomH` arguments:
- `[0,_,1,1,_,1]` (when `mh=1`): Hal lacks insulin but has money; `buyH` would demote `freedomH`
- `[1,1,1,0,_,1]`: Hal has insulin and money; `comH` would demote `freedomH`

---

## API change (`server.pl`)

`handle_args` switches from `argument/3` to `argument/4`:

```prolog
handle_args(_Request) :-
    findall(J, (member(Ag, [hal, carla]),
                argument(Ag, Acts, Val, Scheme),
                arg_json(Ag, Acts, Val, Scheme, J)),
            Args),
    reply_json(Args).
```

`arg_json/5` adds a `"scheme"` field to each argument JSON object:

```json
{ "agent": "hal", "actions": ["doNH", "doNH"], "value": "freedomH", "scheme": "as2" }
```

---

## UI change (`index.html`)

The arrow/connector between action sequence and value chip becomes scheme-aware in plain-English mode:

| scheme | code mode | plain-English mode |
|--------|-----------|--------------------|
| `as1`  | `→`       | *promotes*         |
| `as2`  | `→`       | *protects*         |

`arrowHtml()` is updated to accept the scheme string. The rendering of attacks, extensions, and VAF sections is unchanged — those sections do not carry scheme metadata.

---

## Files changed

| File | Change |
|------|--------|
| `v1.0/args.pl` | `argument/4` replaces `argument/3`; AS2 clauses added for Hal and Carla; `arg/2` wrapper unchanged |
| `v1.0/trans.pl` | Remove `initial_state([1,0,1,1,_,1])` |
| `v1.0/webapp/server.pl` | `handle_args` uses `argument/4`; `arg_json/5` adds `scheme` field |
| `v1.0/webapp/index.html` | `arrowHtml` becomes scheme-aware; `arg_json` parsing reads `scheme` field |

## Files unchanged

| File | Reason |
|------|--------|
| `v1.0/extensions.pl` | Uses `arg/2` only |
| `v1.0/vaf.pl` | Uses `arg/2` only |
| `v1.0/values.pl` | `worse/4` already defined; no changes needed |
| `v1.0/states.pl` | Unchanged |
| `v1.0/actions.pl` | `earnH` already removed |
| `v1.0/jactions.pl` | Unchanged |
