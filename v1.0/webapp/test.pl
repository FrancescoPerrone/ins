:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).

:- use_module('../states').
:- use_module('../actions').
:- use_module('../jactions').
:- use_module('../trans').
:- use_module('../values').
:- use_module('../args').
:- use_module('../extensions').
:- use_module('../vaf').

% Routes
:- http_handler(root(.),          handle_root,       []).
:- http_handler(root(args),       handle_args,       []).
:- http_handler(root(attacks),    handle_attacks,    []).
:- http_handler(root(extensions), handle_extensions, []).
:- http_handler(root(vaf),        handle_vaf,        [prefix]).

% server(Port) starts the HTTP server at the given port.
% e.g. ?- server(8000).  then visit http://127.0.0.1:8000/
server(Port) :-
    http_server(http_dispatch, [port(Port)]).


% GET /  — API description
handle_root(_Request) :-
    reply_json(json([
        status      = ok,
        description = 'INS moral reasoning API',
        routes      = ['/args', '/attacks', '/extensions', '/vaf/:audience']
    ])).


% GET /args
% All arguments: action sequences that promote a subscribed value for Hal.
% Each argument is {"actions": [...], "value": "..."}.
handle_args(_Request) :-
    findall(J, (arg(Acts, Val), arg_json(Acts, Val, J)), Args),
    reply_json(Args).


% GET /attacks
% All attack pairs between arguments.
% Each entry is {"attacker": <arg>, "attacked": <arg>}.
handle_attacks(_Request) :-
    findall(json([attacker=JA, attacked=JB]),
            (attacks(arg(A1,V1), arg(A2,V2)),
             arg_json(A1, V1, JA),
             arg_json(A2, V2, JB)),
            Attacks),
    reply_json(Attacks).


% GET /extensions
% Dung (1995) grounded, preferred, and stable extensions.
% An extension is a list of arguments; preferred and stable return
% a list of such lists.
handle_extensions(_Request) :-
    grounded_extension(Grounded),
    findall(E, preferred_extension(E), Preferred),
    findall(E, stable_extension(E),    Stable),
    ext_json(Grounded, GroundedJSON),
    maplist(ext_json, Preferred, PreferredJSON),
    maplist(ext_json, Stable,    StableJSON),
    reply_json(json([
        grounded  = GroundedJSON,
        preferred = PreferredJSON,
        stable    = StableJSON
    ])).


% GET /vaf
% Lists all named audiences and their value orderings.
%
% GET /vaf/:audience
% VAF preferred extensions for the named audience (Bench-Capon 2003).
% Returns {"audience": "...", "order": [...], "preferred": [...]}.
% Returns 404 if the audience name is not recognised.
handle_vaf(Request) :-
    (   memberchk(path_info(PathInfo), Request),
        atom_concat('/', Aud, PathInfo),
        Aud \= ''
    ->  handle_vaf_audience(Aud)
    ;   findall(json([audience=A, order=O]), audience(A, O), Auds),
        reply_json(Auds)
    ).

handle_vaf_audience(Aud) :-
    (   audience(Aud, Order)
    ->  findall(E, vaf_preferred_extension(E, Aud), Exts),
        maplist(ext_json, Exts, ExtsJSON),
        reply_json(json([
            audience  = Aud,
            order     = Order,
            preferred = ExtsJSON
        ]))
    ;   reply_json(json([error='unknown audience', audience=Aud]), [status(404)])
    ).


% --- Helpers ---

% arg_json(+Acts, +Val, -JSON) converts an argument to a JSON object term.
arg_json(Acts, Val, json([actions=Acts, value=Val])).

% ext_json(+Ext, -JSON) converts a list of arg/2 terms to a JSON array.
ext_json(Ext, JSON) :-
    maplist(arg_to_json, Ext, JSON).

arg_to_json(arg(Acts, Val), json([actions=Acts, value=Val])).
