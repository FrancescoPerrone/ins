in(A,V) :- arg(A,V), not defeated(A,V).

defeated(A,V) :-
  attacks(arg(Ax,Vx), arg(A,V)),
  not higher(V, Vx).

% orderings are transitive
higher(X,Z) :- 
             higher(X,Y), higher(Y,Z).
             
% Example

% a4,v4 attacks a1,v1 
% a3,v3 attacks a2,v2 
% a2,v2 attacks a3,v3 
% a1,v1 attacks a4,v4 
% a2,v2 attacks a4,v4 

arg(a1,v1).
arg(a2,v2).
arg(a3,v3).
arg(a4,v4).

attacks( arg(a4,v4), arg(a1,v1) ).
attacks( arg(a3,v3), arg(a2,v2) ).
attacks( arg(a2,v2), arg(a3,v3) ).
attacks( arg(a1,v1), arg(a4,v4) ).
attacks( arg(a2,v2), arg(a4,v4) ).

% Suppose v1 > v4 and v2 > v3

higher(v4,v1).
higher(v3,v2).


% #hide.

#show in/2.


