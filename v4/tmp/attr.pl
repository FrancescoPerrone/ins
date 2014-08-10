% file: attr.pl
:- module(attr, [val/1, attributesl/1, attributes/1]).


% define attributes in the following space

% attribute(D, A)
% attribute A has domain D
attribute([1,0], insulin).
%attribute([1,0], money).
%attribute([1,0], alive).
%attribute([1,0], shops).


% auxiliar predicates
% do not change

val(V):-
    attributesl(1),
    attribute(Domain, _),
    member(V , Domain).

attributesl(N):-
    findall(E, attribute(_, E), Set),
    length(Set, N).

attributes(Set):-
    findall(Att, attribute(_, Att), Set).
