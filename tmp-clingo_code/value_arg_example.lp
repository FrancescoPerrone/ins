%% Four arguments: a1, a2, a3, a4
%% Values v1, v2, v3, v4 respectively

% a4 attacks a1
% a3 attacks a2
% a2 attacks a3
% a1, a2 attack a4

%% translation

%% with no ordering on values

%*

arg(a1,v1) :- not arg(a4,v4).

arg(a2,v2) :- not arg(a3,v3).

arg(a3,v3) :- not arg(a2,v2).


arg(a4,v4) :- not arg(a1,v1), not arg(a2,v2).

*%



% Suppose v1 > v4 and v2 > v3

% Now we want the defeats
% (A1,V1) defeats (A2,V2) if (A1,V1) attacks (A2,V2) and not(V2 > V1)

% So 

% a4,v4 attacks a1,v1  v1 > v4 so no defeats
% a3,v3 attacks a2,v2  v2 > v3 so no defeats
% a2,v2 attacks a3,v3  not(v3 > v2) so this is defeats
% a1,v1 attacks a4,v4  not(v4 > v1) so this is defeats
% a2,v2 attacks a4,v4  not(v4 > v2) so this is defeats

% So here is the translation for defeats

arg(a1,v1).  % nothing defeats it

arg(a2,v2).  % nothing defeats it

arg(a3,v3) :- not arg(a2,v2).

arg(a4,v4) :- not arg(a1,v1), not arg(a2,v2).
