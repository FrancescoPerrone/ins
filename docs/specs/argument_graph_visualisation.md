# Spec: Argument Graph Visualisation

*Item 19. Comparative study of layout methods for the INS argument graph.*

---

## Goal

Produce a set of comparable visualisations of the argument graph (35 nodes, attack edges)
using multiple layout and embedding strategies. Compare the results visually and analytically.
Select the most informative representation for inclusion in the article.

---

## Data

All data is available from the running HTTP server or directly from the Prolog modules.

| Source | Content |
|---|---|
| `GET /args` | 35 arguments: `{agent, actions, value, scheme}` |
| `GET /attacks` | All attack pairs: `{attacker, attacked}` |
| `GET /extensions` | Preferred extensions: which arguments coexist |
| `GET /vaf/:audience` | VAF preferred extensions per audience |

**Derived data to compute:**

- **Adjacency matrix** A (35×35): `A[i][j] = 1` if arg_i attacks arg_j
- **Feature matrix** F (35×k): per-argument binary features (see below)
- **Extension membership matrix** E (35×13): `E[i][j] = 1` if arg_i is in preferred ext_j

### Feature vector per argument

Each argument encoded as a binary vector over:
- One-hot value: `[lifeH, lifeC, freedomH, freedomC]` (4 bits)
- Scheme: `[as1, as2]` (2 bits)
- One-hot over canonical action set: `[buyH, takH, comH, losH, doNH]` (5 bits, presence in sequence)
- Out-degree in attack graph (normalised)
- In-degree in attack graph (normalised)

Total: ~13 features. Sparse but structured.

---

## Methods to implement and compare

### 1. Force-directed layout — Fruchterman-Reingold

**Library**: NetworkX (`nx.spring_layout`) or Gephi export.

**Principle**: Nodes repel each other like charged particles; edges attract adjacent nodes
like springs. Equilibrium gives a layout where connected nodes cluster and disconnected
ones separate.

**What it shows**: Attack structure directly. Arguments that attack each other frequently
will be pulled together; isolated arguments drift apart.

**Expected result**: Value-clusters should emerge (lifeH arguments form one region, lifeC
another, etc.) because value-homogeneous arguments do not attack each other (same value =
no conflict). Cross-value attack edges pull the clusters together at their boundaries.

**Colour coding**: node colour = value (`lifeH` blue, `lifeC` green, `freedomH` amber,
`freedomC` pink), node shape = scheme (circle AS1, diamond AS2).

---

### 2. Spectral layout

**Library**: NetworkX (`nx.spectral_layout`) using eigenvectors of the graph Laplacian.

**Principle**: Positions nodes along the principal eigenvectors of the Laplacian L = D − A.
Nodes with similar connectivity profiles end up close together.

**What it shows**: Global connectivity structure; long-range separations in the graph. Less
intuitive than force-directed but mathematically grounded.

**Expected result**: The grounded extension being empty (no universally accepted argument)
should be visible as a lack of a clear central cluster. The 13 preferred extensions may
appear as peripheral groupings.

---

### 3. Kamada-Kawai layout

**Library**: NetworkX (`nx.kamada_kawai_layout`).

**Principle**: Minimises stress between graph-theoretic distances (shortest-path) and
geometric distances. More deterministic than Fruchterman-Reingold.

**What it shows**: Graph distance faithfully. Arguments that are many attack-steps apart
are placed far apart in the plane.

---

### 4. UMAP on feature matrix

**Library**: `umap-learn` (`umap.UMAP`).

**Input**: Feature matrix F (35×13) — no graph structure, purely attribute-based.

**Principle**: Learns a low-dimensional manifold that preserves local neighbourhood
structure in the high-dimensional feature space.

**What it shows**: Attribute similarity clustering. Arguments with similar values, schemes,
and action sets will cluster — independent of who attacks whom.

**Comparison value**: If UMAP clusters match force-directed clusters, it confirms that
structural similarity (attack graph) and attribute similarity (feature vector) agree.
Divergence between the two is itself informative.

**Parameters to try**: `n_neighbors` ∈ {5, 10, 15}, `min_dist` ∈ {0.1, 0.3, 0.5}.

---

### 5. UMAP on graph embedding (Node2Vec or adjacency eigenvectors)

**Library**: `node2vec` + `umap-learn`, or spectral embedding → UMAP.

**Input**: Node2Vec embeddings (64-dim) of the attack graph, then UMAP to 2D.
Alternatively: top-k eigenvectors of the adjacency/Laplacian matrix → UMAP.

**Principle**: First embed the graph into a continuous vector space that captures
walk-based proximity; then reduce to 2D for visualisation.

**What it shows**: Graph topology in 2D. More faithful to structural position than UMAP
on features alone; captures higher-order connectivity patterns (triangles, paths).

---

### 6. Extension-membership embedding

**Input**: Extension membership matrix E (35×13). Each argument is a 13-bit vector
encoding which preferred extensions it belongs to.

**Method**: UMAP or PCA on E, then visualise.

**What it shows**: Argumentative compatibility — arguments that coexist in many of the
same extensions cluster together. This is arguably the most semantically meaningful
embedding: proximity = argumentative compatibility.

**Expected result**: Arguments that always appear together (compatible action pairs
promoting the same value under the same audience) should form tight clusters. Arguments
that never coexist (mutually attacking) should be maximally separated.

---

## Implementation plan

**Language**: Python 3.x

**Dependencies**:
```
networkx
matplotlib
numpy
scikit-learn
umap-learn
node2vec          # optional, can substitute with spectral embedding
requests          # to fetch from localhost:8000
```

**File structure**:
```
docs/visualisation/
├── fetch_data.py         — pull args/attacks/extensions from API, build matrices
├── graph_layouts.py      — methods 1–3 (NetworkX layouts)
├── umap_features.py      — method 4 (UMAP on feature matrix)
├── umap_graph.py         — method 5 (UMAP on graph embedding)
├── extension_embed.py    — method 6 (extension membership embedding)
├── plot_utils.py         — shared colour/shape/legend helpers
└── compare.py            — side-by-side figure with all methods
```

**Output**: one figure per method (PNG/SVG, 300 dpi) + one composite comparison figure.

---

## Aesthetic requirements

- **Dark background** matching the webapp palette (`#0b0d13`)
- **Value colours**: lifeH `#60a5fa`, lifeC `#34d399`, freedomH `#fbbf24`, freedomC `#f472b6`
- **Scheme distinction**: solid circle (AS1), hollow/diamond (AS2)
- **Edge colour**: attack edges in muted red (`#9b2c2c`), directed arrows
- **Extension overlay** (optional): convex hulls around arguments belonging to the same
  preferred extension, in a semi-transparent accent colour
- **Labels**: argument IDs or abbreviated action sequences, small font, JetBrains Mono
- **Figure size**: 10×10 inches minimum for single plots; 20×12 for composite

---

## Decision criteria

After generating all plots, select the method that best satisfies:

1. **Separates value clusters clearly** — the primary structural feature of the graph
2. **Reveals extension structure** — which arguments coexist, which are incompatible
3. **Is honest about the graph's properties** — e.g. does not impose structure that isn't there
4. **Is explainable in the article** — reader can understand what distance means

Likely winner hypothesis: **extension-membership UMAP** (method 6) is the most semantically
meaningful for the article; **Fruchterman-Reingold** (method 1) is the most immediately
readable as an attack graph illustration. Both may be included with different purposes.

---

## Article relevance

A well-chosen visualisation can make the following points visually that the article argues
textually:

- The attack graph is maximally contentious (no dominant cluster, no universally central node)
- Value clusters are real but permeable (cross-value attacks prevent clean separation)
- Extension structure is non-trivial (13 preferred extensions, not 1)
- The symmetric attack relation produces a highly regular graph structure — visible as
  symmetry in the layout, and relevant to the one-move proof result
