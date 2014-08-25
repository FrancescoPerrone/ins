:-module(trans, [trans/4, jtrans/4]).

closed_trs([_,_,0,_,_,_], doNoH).
closed_trs([0,1,1,_,_,_], doNoH).
closed_trs([0,0,1,_,_,_], doNoH).

% base case.
% 0 option if you only can doNo from a closed_trs Init

%% init(-I:list)
%
%  Set of all initial possible initial states.
%  
%  @arg I initial state
%  @see state/1
%
initial_state(I):-
    % I = [0,_,1,1,_,1],
    state(I).

trans(Init, Ac, L, Next):-
    initial_state(Init),
    perform(Init, Next, Ac),
    eval(Init, Next, L).

jtrans(Init, Jac, L, Next):-
    performj(Init, Next, Jac),
    eval(Init, Next, L).

findAcs(Acs, In):-
    bagof(Ac, Next^(perform(In, Next, Ac)), Acs).
