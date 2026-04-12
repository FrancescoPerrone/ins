# Webapp Plain-English Toggle — Design Spec

**Date:** 2026-04-10
**Scope:** `v1.0/webapp/index.html`, `v1.0/webapp/server.pl` (renamed from `test.pl`)

---

## Summary

Two changes to the webapp:

1. **Bug fix** — the `/args` endpoint returns HTTP 500 because Carla's joint action terms (e.g. `buyH-comC`) cannot be serialized as JSON. Fixed in `server.pl` by converting compound action terms to atom strings before building JSON.
2. **Plain-English toggle** — a switch in the nav bar lets readers flip between the raw implementation vocabulary ("Code" mode) and a fully translated, jargon-free vocabulary ("Plain English" mode). No italic font anywhere.

---

## 1. Bug Fix — `server.pl` (renamed from `test.pl`)

- Rename `v1.0/webapp/test.pl` → `v1.0/webapp/server.pl`.
- Add `action_to_atom/2` helper that converts a compound term `X-Y` to the atom `'X-Y'` (e.g. `buyH-comC` → `'buyH-comC'`), and passes atoms through unchanged.
- Apply `maplist(action_to_atom, Acts, ActAtoms)` in `arg_json/4` before building the JSON object.
- No changes to any reasoning logic file (`args.pl`, `values.pl`, `states.pl`, etc.).

---

## 2. Toggle Button

- Pill-shaped switch in the top-right of the sticky nav bar.
- Left label: **Code** — Right label: **Plain English**.
- Clicking flips a `data-mode` attribute on `<body>` between `code` (default) and `english`.
- All translation is driven by this attribute — no page reload, no double DOM.

---

## 3. Full Translation Table

### Section titles

| Code mode | English mode |
|---|---|
| Arguments | What Each Agent Proposes |
| Attack Relation | Conflicting Proposals |
| Dung Extensions | Accepted Sets of Proposals |
| VAF by Audience | What Each Audience Endorses |

### Agent panels

| Code mode | English mode |
|---|---|
| Hal — individual | Hal (acts on his own) |
| Carla — joint | Carla (acts with Hal) |

### Extension tabs

| Code mode | English mode |
|---|---|
| Grounded | Core Consensus |
| Preferred | Maximal Accepted Sets |
| Stable | Fully Consistent Sets |

### Structural labels

| Code mode | English mode |
|---|---|
| `→` (arrow) | promotes |
| attacks | challenges |

### Values

| Code | English |
|---|---|
| lifeH | Hal's Life |
| lifeC | Carla's Life |
| freedomH | Hal's Freedom |
| freedomC | Carla's Freedom |

### Individual actions (Hal)

| Code | English |
|---|---|
| buyH | Buy insulin |
| comH | Compensate Carla |
| takH | Take insulin |
| losH | Lose insulin |
| doNH | Do nothing |
| earnH | Earn money |

### Joint action components (Carla's side)

| Code | English |
|---|---|
| buyC | Buy insulin |
| comC | Compensate Hal |
| takC | Take insulin |
| losC | Lose insulin |
| doNC | Do nothing |

Joint actions split on `-` and each half is translated independently, joined with ` · `.
Example: `buyH-comC` → "Buy insulin · Compensate Hal"

---

## 4. Remove Italic Font

All `font-style: italic` declarations removed from the CSS in `index.html`. Affected selectors: `.empty`, `.err`, `.loading`, `.refs`, `.hdr .refs`. Visual distinction is preserved through colour (`var(--text-dim)`).

---

## 5. Implementation Notes

- Raw API data is stored in JS module-level variables after fetch so re-rendering on toggle does not require a second network request.
- All render functions accept a `mode` parameter (`'code'` | `'english'`) and apply translations via lookup maps.
- Value chip class names (e.g. `lifeH`) are kept as-is for CSS colour coding; only the displayed text changes.
- The toggle persists only for the session (no localStorage needed).
