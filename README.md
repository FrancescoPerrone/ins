## Moral Philosophy & Machine Ethics

Can machines show moral intelligence?
This is what I'm trying understand, and _(maybe)_ I'll let you know if I find any good stuff!

Francesco (from a paradox)

<a href="https://plus.google.com/+FrancescoPerrone" rel="publisher">+FrancescoPerrone</a>

###### Tools
* SWI Prolog
* emacs24
* Ubuntu 14.4 LTS
* 100% patience
* 100% coolness
* 0% friends
* 1% friendly support
* Atkinson, K., & Bench-Capon, T. (2006). Addressing moral problems through practical reasoning. In 'Deontic Logic and Artificial Normative Systems' (pp. 8-23). Springer Berlin Heidelberg.
* Alison Chorley, Bench-Capon Trevor, & McBurney, P. (2003). Automating
argumentation for deliberation in cases of conflict of interest. 
_In 'Computational Models of Argument: Proceedings of COMMA 2006_'
(Vol. 144, p. 279). IOS Press.

###### Notes for me

An Action-based Alternating Transition System (AATS) is an (n +
7)-tuple:
```logic
  S = <hQ, q0, Ag, Ac1, ..., Acn, ρ, τ, φ, πi>    where:
```
* Q is a finite, non-empty set of states;
* q0 ∈ Q is the initial state;
* Ag = {1, ..., n} is a finite, non-empty set of agents;
* Aci is a finite, non-empty set of actions, for each i ∈ Ag where Aci∩Acj = ∅
for all i 6= j ∈ Ag;
* ρ : AcAg → 2Q is an action precondition function, which for each action
α ∈ AcAg defines the set of states ρ(α) from which α may be executed;
* JAg is the set of Joint Actions such that every j ∈ JAg is a tuple
hα1, α2, ..., αki where for each αi (i ≤ k) there is some i ∈ Ag such that
αi ∈ Aci.
* τ : Q x JAg → Q is a partial system transition function, which defines the
state τ(q, j) that would result by the performance of j from state q - note
that, as this function is partial, not all joint actions are possible in all states (cf. the precondition function above);
* φ is a finite, non-empty set of atomic propositions; and
* π : Q → 2φ is an interpretation function, which gives the set of primitive
propositions satisfied in each state: if p ∈ π(q), then this means that the
propositional variable p is satisfied (equivalently, true) in state q.
