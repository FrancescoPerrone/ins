:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

:- multifile http:location/3.
:- dynamic   http:location/3.

% this defines the working roots
:- http_handler(root(.), working_msg, []).
:- http_handler(root(rooms), working_msg, []).

:- http_handler('/rooms/kitchen', my_handler_code(contains(nothing)), []).
:- http_handler('/rooms/bedroom', my_handler_code(contains(bed)), []).
:- http_handler('/rooms/cellar',  my_handler_code(contais(fridge)), []).

% server(8000) will start the server at 8000
% root is at http://127.0.0.1:Port/
server(Port):-
    http_server(http_dispatch, [port(Port)]).

% content example
working_msg(_Request) :-
    format('Content-type: text/html~n~n'),
    format('<html><head><title>Test</title></head><body><h2>Great man! It''s working!</h2><p>Francesco</p></body></html>~n').

my_handler_code(WhatToSay, _) :-
    format(WhatToSay,'~n').

