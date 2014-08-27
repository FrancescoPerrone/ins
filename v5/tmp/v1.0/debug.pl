/* File: debug.pl

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

tc:-  
    message,
    repeat,
    nl,
    read(State),
    ( State == e
    -> !
    ;  compute(State),
       fail
    ).

compute(Init):-
    ( not(state(Init)) 
      -> error(Init)
      ; header,
	trans(Init, Ac, L, Next, 1),
	output(Init, Ac, L, Next),
	fail).
compute(_):- footer.

error(Init):-
    nl,
    ansi_format([bold,fg(red)], 'invalid input: ~w', [Init]),
    fail.

footer:-
    nl,
    statistics(runtime, [T]),
    ansi_format([faint,fg(cyan)], 'Runtime: ~`.t ~f~34|', [T]),
    nl.

header:-
    nl,
    tab(3), write('s'),
    tab(4), write('ini'), 
    tab(14), write('act'), 
    tab(5),  write('new'), 
    tab(14), write('val'),
    nl.

output(Init, Ac, L, Next):-
    wrt(Init, Ac, L, Next).
    
wrt(Init, Ac, L, Next):-
    tab(3), write(1),
    tab(4), write(Init), 
    tab(4), write(Ac), 
    tab(4), write(Next), 
    tab(4), write(L),
    nl.

message:-
    cl,
    ansi_format([faint,fg(cyan)], '--------------------------~w', [------]),nl,
    ansi_format([faint,fg(cyan)], 'Transitions Computer v0.0 ~w', [tester]),nl,
    ansi_format([faint,fg(cyan)], '--------------------------~w', [------]),nl,
    write('Type a state (''e'' to exit)'), nl.
cl:-
    format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).
