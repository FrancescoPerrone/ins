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



% transition calulator begins
% -----------------------------

tc:-  
    message('Transitions Computer v0.1'),
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
      ; tab,
	trans(Init, Ac, L, Next, 1),
	output(Init, Ac, L, Next),
	fail).
compute(_):- footer.

% output format

tab:-
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



% tran_label calulator begins
% -----------------------------

tl:-  
    message('Trans_label Computer v0.0'),
    repeat,
    nl,
    read(State),
    ( State == e
    -> !
    ;  com_label(State),
       fail
    ).

com_label(Init):-
    ( not(state(Init)) 
      -> error(Init)
      ; tab_l,
	trans_label(Init, L, A, N, B, P),
	out_label(Init, L, A, N, B, P),
	fail).
com_label(_):- footer.


% output format

tab_l:-
    nl,
    tab(3),  write('ini'), 
    tab(12), write('as1'),  
    tab(17), write('as2'),
    tab(19), write('val'),
    nl.

out_label(Init, L, A, N, B, P):-
    wrt_label(Init, L, A, N, B, P).
    
wrt_label(Init, L, A, N, B, P):-
    tab(3), write(Init), 
    tab(2), write(A-N), 
    tab(2), write(B-P), 
    tab(4), write(L),
    nl.


% jtrans calulator begins
% -----------------------------

jt:-  
    message('Joint Transitions Computer v0.0'),
    repeat,
    nl,
    read(State),
    ( State == e
    -> !
    ;  jcompute(State),
       fail
    ).

jcompute(Init):-
    ( not(state(Init)) 
      -> error(Init)
      ; jtab,
	jtrans(Init, Ac, L, Next),
	joutput(Init, Ac, L, Next),
	fail).
jcompute(_):- footer.

% output format

jtab:-
    nl,
    tab(3), write('s'),
    tab(4), write('ini'), 
    tab(14), write('act'), 
    tab(10),  write('new'), 
    tab(14), write('val'),
    nl.

joutput(Init, Ac, L, Next):-
    jwrt(Init, Ac, L, Next).
    
jwrt(Init, Ac, L, Next):-
    tab(3), write(1),
    tab(4), write(Init), 
    tab(4), write(Ac), 
    tab(4), write(Next), 
    tab(4), write(L),
    nl.





% general outputs
% ------------------------

message(ID):-
    cl,
    nl,
    ansi_format([faint,fg(cyan)],'~`-t~85|', []),nl,
    ansi_format([faint,fg(cyan)], '~w', [ID]),nl,
    ansi_format([faint,fg(cyan)],'~`-t~85|', []),nl, nl,
    ansi_format([faint,fg(white), font(2)],'~w', ['Type state (or ''e'' to exit)']),nl.

cl:-
    format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).

error(Init):-
    nl,
    ansi_format([faint,fg(white)], 'wrong term: ''~w~w ~n', [Init, '''']),
    fail.

footer:-
    nl,
    statistics(runtime, [T]),
    ansi_format([faint,fg(cyan)], 'Runtime: ~`.t ~f~34|', [T]),
    nl.

sformat([H|Rest]):-
    ( H = +_
      -> (ansi_format([bold,fg(white)],  '~w', [H]))
      ;  ansi_format([faint,fg(white)],  '~w', [H])),
    sformat(Rest).
