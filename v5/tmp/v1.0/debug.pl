/** File: debug.pl

Debugging framework and main.pl tester.

@author Francesco Perrone

*/

% Starts the PlDoc services
% -----------------------------

% Start PlDoc at port 3000
:- doc_server(3000).
% Start PlDoc at port 3000    
:- doc_collect(true).
:- portray_text(true).  

% File to test
% -----------------------------
:- use_module(action). 
:- use_module(jaction). 
:- use_module(state).
:- use_module(trans).
:- use_module(value).

% main test
% -----------------------------

main:-  
    message,
    repeat,
    tab(1),
    write('> '),
    read(State),
    (  State == 0
    -> !
    ;  compute(State),
       fail
    ).

compute(Init):-
    trans(Init, Ac, L, Next),
    wrt(Init, Ac, L, Next),
    fail.
compute.

wrt(Init, Ac, L, Next):-
    write(Init), tab(1), 
    write(Ac), tab(1),
    write('-->'), tab(1),
    write(Next), tab(2), write(L),
    nl.

message:-
    cl,
    ansi_format([faint,fg(cyan)], '------------------------~w', [------]),nl,
    ansi_format([faint,fg(cyan)], 'Transition Calculator - ~w', [tester]),nl,
    ansi_format([faint,fg(cyan)], '------------------------~w', [------]),nl,
    write('Enter a state (or ''0'' to exit)'), nl.
cl:-
    format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).
