:-module(trans, [trans/5, trans_label/6]).

/** <module> Transitiona System

@tbd [ ] all documentation
@tbd [ ] finalize trans/5
@tbd [ ] finalize trans_label/4
@tbd [ ] move from trans_label/4 to trans_label/6
@tbd [ ] change name trans_label
@tbd [ ] work on jtrans

@author Francesco Perrone
@license GNU

*/

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

trans(Init, Ac, L, Next, 1):-
    initial_state(Init),
    perform(Init, Next, Ac),
    eval(Init, Next, L).
trans(Init, Ac, _, Next, N):-
    Step is N - 1,
    N > 0,
    initial_state(Init),
    perform(Init, X, Ac),
    initial_state(X),              % redundant?
    trans(X, Ac, _, Next, Step).

%% trans_label(Init, L, A, N, B, P)
%
%  Transition predicate.
%  Evaluation is done confronting two different
%  next states.
%
%  @arg Init Initial state
%  @arg L The label: values status
%  @arg A Action
%  @arg N Next state applying action A from Init
%  @arg B Action (B ≠ A)
%  @arg P Next state applying action B from Init
%
%  @tbd find approrpiate name
%
trans_label(Init, L, A, N, B, P):-
    initial_state(Init),
    perform(Init, N, A),
    perform(Init, P, B),
    not(N == P),
    eval(N, P, L).

jtrans(Init, Jac, L, Next):-
    performj(Init, Next, Jac),
    eval(Init, Next, L).

/*
findAcs(Acs, In):-
    bagof(Ac, Next^(perform(In, Next, Ac)), Acs).
*/
