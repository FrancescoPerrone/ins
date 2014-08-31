%           File tested

:- use_module(states).
:- use_module(actions).
:- use_module(trans).
:- use_module(values).
:- use_module(args).


%           Starts the PlDoc services

:- doc_server(_).
:- doc_collect(true).
:- portray_text(true).


% @tbd:


%           Listener

