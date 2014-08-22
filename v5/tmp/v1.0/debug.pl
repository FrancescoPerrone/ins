:- doc_server(3000).    % Start PlDoc at port 3000
:- doc_collect(true).
:- portray_text(true).  % Enable portray of strings

:- use_module(action). 
:- use_module(state).
:- use_module(trans).
:- use_module(val).
%:- use_module(jaction).  
