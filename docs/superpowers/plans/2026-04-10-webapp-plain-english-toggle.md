# Webapp Plain-English Toggle — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Code/Plain-English toggle to the webapp, fix the HTTP 500 on `/args`, rename `test.pl` to `server.pl`, and remove all italic font.

**Architecture:** Two files change — `server.pl` (renamed + bug fixed) and `index.html` (CSS + HTML + JS). The JS stores fetched data in module-level variables and re-renders all sections on toggle without additional network requests. Static labels use `data-code`/`data-english` HTML attributes; dynamic content is re-rendered by calling render functions that read a module-level `MODE` variable.

**Tech Stack:** SWI-Prolog HTTP server, vanilla JS, HTML/CSS.

---

## Task 1 — Rename `test.pl` → `server.pl` and fix the HTTP 500

**Files:**
- Rename: `v1.0/webapp/test.pl` → `v1.0/webapp/server.pl`
- Modify: `v1.0/webapp/server.pl` — fix `arg_json/4` to serialize joint action terms

The bug: Carla's joint actions are Prolog compound terms like `buyH-comC` (i.e. `-(buyH,comC)`). SWI-Prolog's JSON library cannot serialize compound terms and throws an exception, producing HTTP 500. Fix: convert each action term to an atom before building the JSON.

- [ ] **Step 1: Rename the file**

```bash
cd /home/francesco/Desktop/research/ins/ins/v1.0/webapp
mv test.pl server.pl
```

- [ ] **Step 2: Add `action_to_atom/2` helper and fix `arg_json/4`**

Open `v1.0/webapp/server.pl`. Replace the existing `arg_json` helper (last section of the file, around line 138–140):

```prolog
% arg_json(+Ag, +Acts, +Val, -JSON) — argument with agent field.
% Action terms are converted to atoms so the JSON library can serialise them.
arg_json(Ag, Acts, Val, json([agent=Ag, actions=ActAtoms, value=Val])) :-
    maplist(action_to_atom, Acts, ActAtoms).

% Converts a joint-action compound term H-C to the dash-separated atom 'H-C'.
% Plain atoms pass through unchanged.
action_to_atom(H-C, Atom) :-
    !,
    atomic_list_concat([H, C], '-', Atom).
action_to_atom(A, A).
```

- [ ] **Step 3: Verify `/args` returns JSON**

Kill any running server and restart with the renamed file:

```bash
fuser -k 8000/tcp 2>/dev/null; true
cd /home/francesco/Desktop/research/ins/ins/v1.0/webapp
swipl -g "server(8000)" server.pl &
sleep 2
curl -s http://localhost:8000/args | head -c 200
```

Expected: a JSON array starting with `[{"agent":` — no error, no 500.

- [ ] **Step 4: Commit**

```bash
cd /home/francesco/Desktop/research/ins/ins
git add v1.0/webapp/server.pl
git rm v1.0/webapp/test.pl
git commit -m "fix: rename test.pl -> server.pl, fix HTTP 500 on /args (joint action serialisation)"
```

---

## Task 2 — CSS: remove italic font and add toggle styles

**Files:**
- Modify: `v1.0/webapp/index.html` — CSS block only

- [ ] **Step 1: Remove all `font-style: italic` declarations**

In `index.html`, find and remove every `font-style: italic` occurrence. They appear in these rules:

```css
/* REMOVE font-style: italic from each of these */
.hdr .refs { ... font-style: italic; ... }
.empty { color: var(--text-dim); font-style: italic; }
.err   { color: #e05555; font-style: italic; }
.loading { color: var(--text-dim); font-style: italic; padding: 0.5em 0; }
```

Replace with (remove the `font-style` line, keep the rest):

```css
.hdr .refs {
  margin-top: 0.5em;
  font-size: 0.75em;
  color: var(--text-dim);
}
.empty { color: var(--text-dim); }
.err   { color: #e05555; }
.loading {
  color: var(--text-dim);
  padding: 0.5em 0;
}
```

- [ ] **Step 2: Add toggle CSS**

Add the following rules at the end of the `<style>` block, before the closing `</style>`:

```css
/* ── Mode toggle ──────────────────────────────────────────── */
.mode-switch {
  position: absolute;
  right: 1.5em;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  background: var(--bg-elevated);
  border: 1px solid var(--border-mid);
  border-radius: 20px;
  padding: 3px;
  gap: 2px;
  cursor: pointer;
  user-select: none;
}
.mode-opt {
  padding: 0.28em 0.9em;
  border-radius: 16px;
  font-size: 0.71em;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: var(--text-dim);
  transition: color 0.15s, background 0.15s;
}
.mode-opt.active {
  background: var(--bg-card);
  color: var(--text-bright);
  border: 1px solid var(--border);
}
.arr-label {
  color: var(--text-dim);
  padding: 0 0.5em;
  font-size: 0.82em;
  font-family: 'Cormorant Garamond', Georgia, serif;
}
```

Also add `position: relative;` to the existing `.nav` rule so the absolute-positioned toggle is anchored correctly:

```css
.nav {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(11,13,19,0.93);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border);
  display: flex;
  justify-content: center;
  position: relative;  /* ADD THIS LINE */
}
```

Wait — `.nav` already has `position: sticky`. In CSS the last `position` declaration wins, so replace the block to have both sticky behavior and `position: relative` won't work. Use a wrapper div instead. See Task 3 Step 1 for the HTML approach.

Revised: keep `.nav` as-is and instead use `margin-left: auto` on `.mode-switch`:

```css
.mode-switch {
  display: flex;
  align-items: center;
  background: var(--bg-elevated);
  border: 1px solid var(--border-mid);
  border-radius: 20px;
  padding: 3px;
  gap: 2px;
  cursor: pointer;
  user-select: none;
  margin-left: auto;
  margin-right: 1.5em;
}
```

- [ ] **Step 3: Visual check (no server needed)**

Open `index.html` in a browser directly (`file://...`) or via the server. Confirm no text is italic anywhere on the page.

---

## Task 3 — HTML: add toggle switch and data attributes to static labels

**Files:**
- Modify: `v1.0/webapp/index.html` — HTML body only

- [ ] **Step 1: Add toggle switch to nav**

Replace the `<nav class="nav">` block:

```html
<nav class="nav">
  <a href="#sec-args">Arguments</a>
  <a href="#sec-attacks">Attacks</a>
  <a href="#sec-extensions">Extensions</a>
  <a href="#sec-vaf">VAF</a>
</nav>
```

With:

```html
<nav class="nav">
  <a href="#sec-args"       data-code="Arguments"    data-english="What Each Agent Proposes">Arguments</a>
  <a href="#sec-attacks"    data-code="Attacks"       data-english="Conflicting Proposals">Attacks</a>
  <a href="#sec-extensions" data-code="Extensions"   data-english="Accepted Sets">Extensions</a>
  <a href="#sec-vaf"        data-code="VAF"           data-english="What Each Audience Endorses">VAF</a>
  <div class="mode-switch" id="mode-switch">
    <span class="mode-opt active" data-mode="code">Code</span>
    <span class="mode-opt" data-mode="english">Plain English</span>
  </div>
</nav>
```

- [ ] **Step 2: Add data attributes to section headings**

Replace each `<h2 class="sec-title">` in the HTML body:

```html
<!-- Arguments section -->
<h2 class="sec-title" data-code="Arguments" data-english="What Each Agent Proposes">Arguments</h2>

<!-- Attacks section -->
<h2 class="sec-title" data-code="Attack Relation" data-english="Conflicting Proposals">Attack Relation</h2>

<!-- Extensions section -->
<h2 class="sec-title" data-code="Dung Extensions" data-english="Accepted Sets of Proposals">Dung Extensions</h2>

<!-- VAF section -->
<h2 class="sec-title" data-code="VAF by Audience" data-english="What Each Audience Endorses">VAF by Audience</h2>
```

- [ ] **Step 3: Commit CSS + HTML changes**

```bash
cd /home/francesco/Desktop/research/ins/ins
git add v1.0/webapp/index.html
git commit -m "style: remove italic font, add mode toggle CSS and HTML scaffold"
```

---

## Task 4 — JS: translation maps, refactored render functions, toggle wiring

**Files:**
- Modify: `v1.0/webapp/index.html` — `<script>` block only

Replace the entire `<script>` block with the following. This is a full replacement — the logic is the same but refactored to support mode-aware rendering.

- [ ] **Step 1: Replace the `<script>` block**

```html
<script>
/* ── Mode ────────────────────────────────────────────────── */
let MODE = 'code';
const DATA = { args: null, attacks: null, extensions: null, vaf: null };

/* ── Translation maps ────────────────────────────────────── */
const VALUE_LABELS = {
  lifeH:    "Hal's Life",
  lifeC:    "Carla's Life",
  freedomH: "Hal's Freedom",
  freedomC: "Carla's Freedom",
};

const ACTION_LABELS = {
  buyH:  'Buy insulin',
  comH:  'Compensate Carla',
  takH:  'Take insulin',
  losH:  'Lose insulin',
  doNH:  'Do nothing',
  earnH: 'Earn money',
  buyC:  'Buy insulin',
  comC:  'Compensate Hal',
  takC:  'Take insulin',
  losC:  'Lose insulin',
  doNC:  'Do nothing',
};

function translateValue(v) {
  return MODE === 'english' && VALUE_LABELS[v] ? VALUE_LABELS[v] : v;
}

function translateAction(a) {
  if (MODE !== 'english') return a;
  if (typeof a === 'string' && a.includes('-')) {
    return a.split('-').map(p => ACTION_LABELS[p] || p).join(' · ');
  }
  return ACTION_LABELS[a] || a;
}

function translateAudience(name) {
  if (MODE !== 'english') return name;
  return name.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
}

/* ── Helpers ─────────────────────────────────────────────── */
function valChip(v) {
  return `<span class="val ${v}">${translateValue(v)}</span>`;
}

function actsLabel(a) {
  const actions = Array.isArray(a.actions) ? a.actions : [String(a.actions)];
  return actions.map(translateAction).join(', ');
}

function arrowHtml() {
  return MODE === 'english'
    ? '<span class="arr-label">promotes</span>'
    : '<span class="arr">→</span>';
}

function attacksLabel() {
  return MODE === 'english' ? 'challenges' : 'attacks';
}

function argInline(a) {
  return `<span class="acts">${actsLabel(a)}</span>${arrowHtml()}${valChip(a.value)}`;
}

function fmtExt(ext) {
  if (!ext || ext.length === 0) return '<span class="empty">∅</span>';
  return ext.map(a => `<div class="ext-arg">${argInline(a)}</div>`).join('');
}

function get(url) {
  return fetch(url).then(r => {
    if (!r.ok) throw new Error('HTTP ' + r.status);
    return r.json();
  });
}

function showErr(id, msg) {
  document.getElementById(id).innerHTML = `<span class="err">Error: ${msg}</span>`;
}

/* ── Static label swap ───────────────────────────────────── */
function applyStaticLabels() {
  document.querySelectorAll('[data-code]').forEach(el => {
    el.textContent = MODE === 'english' ? el.dataset.english : el.dataset.code;
  });
}

/* ── Arguments ───────────────────────────────────────────── */
function renderArgs() {
  const args = DATA.args;
  const hal   = args.filter(a => a.agent === 'hal');
  const carla = args.filter(a => a.agent === 'carla');

  document.getElementById('args-count').textContent =
    `${args.length} total · ${hal.length} Hal · ${carla.length} Carla`;

  const halLabel   = MODE === 'english' ? 'Hal (acts on his own)' : 'Hal — individual';
  const carlaLabel = MODE === 'english' ? 'Carla (acts with Hal)' : 'Carla — joint';

  function panel(list, ag, label) {
    const rows = list.map(a =>
      `<div class="arg-row">
         <span class="acts">${actsLabel(a)}</span>
         ${arrowHtml()}
         ${valChip(a.value)}
       </div>`
    ).join('');
    return `<div class="agent-panel">
      <div class="agent-panel-hdr">
        <span class="${ag}">${label}</span>
        <span class="sec-count">${list.length}</span>
      </div>
      ${rows || '<div class="arg-row empty">No arguments</div>'}
    </div>`;
  }

  document.getElementById('args-body').innerHTML =
    `<div class="args-grid">
       ${panel(hal,   'hal',   halLabel)}
       ${panel(carla, 'carla', carlaLabel)}
     </div>`;
}

/* ── Attacks ─────────────────────────────────────────────── */
function renderAttacks() {
  const data = DATA.attacks;
  document.getElementById('attacks-count').textContent = `${data.length} pairs`;

  const rows = data.map(a =>
    `<div class="attack-row">
       <div class="attack-side">
         <span class="acts">${actsLabel(a.attacker)}</span>
         ${arrowHtml()}${valChip(a.attacker.value)}
       </div>
       <div class="attack-mid">
         <span>⟶</span><span class="lbl">${attacksLabel()}</span><span>⟶</span>
       </div>
       <div class="attack-side right">
         ${valChip(a.attacked.value)}<span class="arr">←</span>
         <span class="acts">${actsLabel(a.attacked)}</span>
       </div>
     </div>`
  ).join('');

  document.getElementById('attacks-body').innerHTML =
    `<div class="attacks-list">${rows || '<span class="empty">No attacks</span>'}</div>`;
}

/* ── Extensions ──────────────────────────────────────────── */
function renderExtensions() {
  const data = DATA.extensions;

  // Preserve active tab across re-renders
  const activePanel = document.querySelector('#extensions-body .ext-panel.active')?.id || 'ep-grounded';

  const tabGrounded  = MODE === 'english' ? 'Core Consensus'        : 'Grounded';
  const tabPreferred = MODE === 'english' ? 'Maximal Accepted Sets' : 'Preferred';
  const tabStable    = MODE === 'english' ? 'Fully Consistent Sets' : 'Stable';

  const grHtml = `<div class="ext-list"><div class="ext-item">
    <div class="ext-args">${fmtExt(data.grounded)}</div></div></div>`;

  function extList(exts) {
    if (exts.length === 0) return '<span class="empty">none</span>';
    return '<div class="ext-list">' + exts.map((e, i) =>
      `<div class="ext-item">
         <span class="ext-num">${i + 1}.</span>
         <div class="ext-args">${fmtExt(e)}</div>
       </div>`
    ).join('') + '</div>';
  }

  document.getElementById('extensions-body').innerHTML =
    `<div class="ext-tabs">
       <div class="ext-tab" data-panel="ep-grounded">${tabGrounded}</div>
       <div class="ext-tab" data-panel="ep-preferred">${tabPreferred} (${data.preferred.length})</div>
       <div class="ext-tab" data-panel="ep-stable">${tabStable} (${data.stable.length})</div>
     </div>
     <div id="ep-grounded"  class="ext-panel">${grHtml}</div>
     <div id="ep-preferred" class="ext-panel">${extList(data.preferred)}</div>
     <div id="ep-stable"    class="ext-panel">${extList(data.stable)}</div>`;

  // Restore active tab
  const restoreTab = document.querySelector(`[data-panel="${activePanel}"]`);
  const restorePanel = document.getElementById(activePanel);
  (restoreTab  || document.querySelector('[data-panel="ep-grounded"]')).classList.add('active');
  (restorePanel || document.getElementById('ep-grounded')).classList.add('active');
}

/* ── VAF ─────────────────────────────────────────────────── */
function renderVAF() {
  const results = DATA.vaf;

  const cards = results.map(([pref, gnd]) => {
    const orderHtml = pref.order
      .map(valChip)
      .join('<span class="ord-sep">›</span>');

    const gndHtml  = `<div class="aud-ext-item">${fmtExt(gnd.grounded)}</div>`;
    const prefHtml = pref.preferred.length === 0
      ? '<div class="aud-ext-item empty">none</div>'
      : pref.preferred.map(ext =>
          `<div class="aud-ext-item">${
            ext.map(argInline).join('<span class="aud-sep">·</span>')
          }</div>`
        ).join('');

    const audName = translateAudience(pref.audience);
    const gndTitle  = MODE === 'english' ? 'Core Consensus'        : 'Grounded';
    const prefTitle = MODE === 'english' ? 'Maximal Accepted Sets' : 'Preferred';

    return `<div class="aud-card">
      <div class="aud-card-hdr">
        <div class="aud-name">${audName}</div>
        <div class="aud-order">${orderHtml}</div>
      </div>
      <div class="aud-body">
        <p class="aud-sub-title">${gndTitle}</p>
        <div class="aud-ext-list">${gndHtml}</div>
        <p class="aud-sub-title" style="margin-top:0.9em">
          ${prefTitle} (${pref.preferred.length})
        </p>
        <div class="aud-ext-list">${prefHtml}</div>
      </div>
    </div>`;
  }).join('');

  document.getElementById('vaf-body').innerHTML = `<div class="vaf-grid">${cards}</div>`;
}

/* ── Toggle ──────────────────────────────────────────────── */
document.getElementById('mode-switch').addEventListener('click', e => {
  const btn = e.target.closest('.mode-opt');
  if (!btn || btn.dataset.mode === MODE) return;
  MODE = btn.dataset.mode;
  document.querySelectorAll('.mode-opt').forEach(o =>
    o.classList.toggle('active', o.dataset.mode === MODE)
  );
  applyStaticLabels();
  if (DATA.args)       renderArgs();
  if (DATA.attacks)    renderAttacks();
  if (DATA.extensions) renderExtensions();
  if (DATA.vaf)        renderVAF();
});

/* ── Tab switching (delegated) ───────────────────────────── */
document.addEventListener('click', e => {
  const tab = e.target.closest('.ext-tab');
  if (!tab) return;
  const sec = tab.closest('.sec');
  sec.querySelectorAll('.ext-tab').forEach(t => t.classList.remove('active'));
  sec.querySelectorAll('.ext-panel').forEach(p => p.classList.remove('active'));
  tab.classList.add('active');
  document.getElementById(tab.dataset.panel).classList.add('active');
});

/* ── Fetch ───────────────────────────────────────────────── */
get('/args').then(args => {
  DATA.args = args;
  renderArgs();
}).catch(e => showErr('args-body', e.message));

get('/attacks').then(data => {
  DATA.attacks = data;
  renderAttacks();
}).catch(e => showErr('attacks-body', e.message));

get('/extensions').then(data => {
  DATA.extensions = data;
  renderExtensions();
}).catch(e => showErr('extensions-body', e.message));

get('/vaf').then(audiences => {
  return Promise.all(
    audiences.map(a =>
      Promise.all([
        get(`/vaf/${a.audience}`),
        get(`/vaf/${a.audience}/grounded`)
      ])
    )
  );
}).then(results => {
  DATA.vaf = results;
  renderVAF();
}).catch(e => showErr('vaf-body', e.message));
</script>
```

- [ ] **Step 2: Commit**

```bash
cd /home/francesco/Desktop/research/ins/ins
git add v1.0/webapp/index.html
git commit -m "feat: add Code/Plain-English toggle, translate all labels and codes"
```

---

## Task 5 — Restart server and verify

- [ ] **Step 1: Kill any running server and restart**

```bash
fuser -k 8000/tcp 2>/dev/null; true
cd /home/francesco/Desktop/research/ins/ins/v1.0/webapp
swipl -g "server(8000)" server.pl &
sleep 2
curl -s http://localhost:8000/args | python3 -m json.tool | head -20
```

Expected: clean JSON array with `agent`, `actions` (plain strings), `value` fields.

- [ ] **Step 2: Open the browser and verify**

Visit `http://localhost:8000/` and confirm:

1. All four sections load without errors.
2. No text is italic on the page.
3. The "Code / Plain English" toggle appears in the nav bar (right side).
4. Clicking "Plain English" translates all labels: section headings, tab names, agent panels, action codes, value chips, and the `→` arrow becomes "promotes".
5. Clicking back to "Code" restores all original labels.
6. Switching modes while an extension tab is active preserves the active tab.

- [ ] **Step 3: Commit docs**

```bash
cd /home/francesco/Desktop/research/ins/ins
git add docs/superpowers/plans/2026-04-10-webapp-plain-english-toggle.md
git add docs/superpowers/specs/2026-04-10-webapp-plain-english-toggle-design.md
git commit -m "docs: add design spec and implementation plan for plain-english toggle"
```
