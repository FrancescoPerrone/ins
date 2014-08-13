%% Four arguments: a1, a2, a3, a4

% a4 attacks a1
% a3 attacks a2
% a2 attacks a3
% a1, a2 attack a4

%% translation



% r1: a1 :- not a1, not a4.
a1 :- not a4.

a2 :- not a3.

a3 :- not a2.

% r4: a4 :- not a4, not a1, not a2.
a4 :- not a1, not a2.

