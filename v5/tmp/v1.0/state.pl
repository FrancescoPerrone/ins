:- module(state, [state/1, attributes/1]).
:- use_module(library(pldoc)).

/** <module> State representation and definition

This module provides a definition and representation patterns for
agent's state. According to this definition a state is an ordered 
list of attributes. Attributes are agent's properties and 
not the properties of a state.

A state could be representated as <i,m,a> or <i,m,a,i,m,a> for two agents.
i,m,a are the agent's attributes and each of them can be true (1) or false (0).

In particular, 'i' is true if agent has insulin, 'm' is true if agent has money and 'a' is true if agent is alive.
The above are false otherwhise.

e.g.
==
?- state(S).
S = [1, 1, 1, 1, 1, 1] ;
S = [1, 1, 1, 1, 1, 0] ;
S = [1, 1, 1, 1, 0, 1] ;
S = [1, 1, 1, 1, 0, 0] 
[...]
==

@author Francesco Perrone
@license GPL
@copyright tba
*/


%% attributes(List:list) is semidet
% 
%  Pattern for a valid list of attributes.
%  Each attribute will have a value domain.
%
%  @arg List list of attributes
%  @see domain/2

attributes([ih,mh,ah,ic,mc,ac]).

%% domain(Name:ground, Domain:list) is semidet
%  @arg Name ground term, name of attribute
%  @arg Domain list of possible values

domain(ih, [1,0]).
domain(mh, [1,0]).
domain(ah, [1,0]).
domain(ic, [1,0]).
domain(mc, [1,0]).
domain(ac, [1,0]).

%% state(+State:attributes) is semidet
%
%  A valid state, meaning that 'State' is state if it is a orderd
%  list (order given by attributes) of attribute
%  values (given by domain).
%
%  @arg State a list of attributes' values
%  @see attributes/1
%  @see domain/2

state(State):-
    attributes(Attributes),
    state_aux(Attributes, State).

% Auxiliary preds

state_aux([],[]).
state_aux([Attribute|Attributes],[Val|Values]):-
    domain(Attribute, Dom),
    member(Val, Dom),
    state_aux(Attributes, Values).

%    specifies the order in a state
attribute(Attribute, State, Val):-
    attributes(Attributes),
    attribute_aux(Attribute, Attributes, State, Val).

attribute_aux(Attribute, [Attribute|_], [Val|_], Val):-
    domain(Attribute, Dom),
    member(Val, Dom).
attribute_aux(Attribute, [_|MoreAttributes], [_|RestStates], Val):-
    attribute_aux(Attribute, MoreAttributes, RestStates, Val).
