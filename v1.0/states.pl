:- module(state, [agent/1, state/1, attributes/1, attribute/3]).
:- use_module(library(pldoc)).

/** <module> Agent's State representation and definition

This module provides definition patterns for an
agent's state. A state is an ordered list of attributes. 
Attributes are agent's properties and not the properties of a state.

A state is represented as <i,m,a,i,m,a> for two agents.

In particular, 'i' is true if agent has insulin, 'm' is true if agent has money 
and 'a' is true if agent is alive. They are false otherwhise.


@author Francesco Perrone
@license GPL
*/

agent(hal).
agent(carla).

%% attributes(List:list) is semidet
% 
%  Pattern for a valid list of attributes.
%  Each attribute will have a value in it's domain.
%
%  @arg List list of attributes
%  @see domain/2
%
attributes([ih,mh,ah,ic,mc,ac]).

%% domain(Name:ground, Domain:list) is semidet
%  @arg Name ground term, name of attribute
%  @arg Domain list of possible values
%
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
%
state(State):-
    attributes(Attributes),
    state_aux(Attributes, State).

% Auxiliary preds

% pairs attributes with their domain-values
state_aux([],[]).
state_aux([Attribute|Attributes],[Val|Values]):-
    domain(Attribute, Dom),
    member(Val, Dom),
    state_aux(Attributes, Values).

% retrivers/assigns a attribute's value given a state 
attribute(Attribute, State, Val):-
    attributes(Attributes),
    attribute_aux(Attribute, Attributes, State, Val).

attribute_aux(Attribute, [Attribute|_], [Val|_], Val):-
    domain(Attribute, Dom),
    member(Val, Dom).
attribute_aux(Attribute, [_|MoreAttributes], [_|RestStates], Val):-
    attribute_aux(Attribute, MoreAttributes, RestStates, Val).
