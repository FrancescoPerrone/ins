:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

% Capture the webapp directory at load time so handle_root can find index.html.
:- dynamic webapp_dir/1.
:- prolog_load_context(file, F), file_directory_name(F, D), assertz(webapp_dir(D)).

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
    http_server(http_dispatch, [port(Port)]),
    thread_get_message(_).


% GET /  — serves the HTML frontend (index.html in the same directory)
handle_root(Request) :-
    webapp_dir(Dir),
    atom_concat(Dir, '/index.html', Index),
    http_reply_file(Index, [unsafe(true)], Request).


% GET /args
% All arguments for all agents.
% Hal uses individual action sequences; Carla uses joint action sequences.
% Each entry is {"agent": "...", "actions": [...], "value": "...", "scheme": "as1"|"as2"}.
handle_args(_Request) :-
    findall(J, (member(Ag, [hal, carla]),
                argument(Ag, Acts, Val, Scheme),
                arg_json(Ag, Acts, Val, Scheme, J)),
            Args),
    reply_json(Args).


% GET /attacks
% All attack pairs between arguments.
% Each entry is {"attacker": <arg>, "attacked": <arg>}.
handle_attacks(_Request) :-
    findall(json([attacker=JA, attacked=JB]),
            (attacks(arg(A1,V1), arg(A2,V2)),
             arg_to_json(arg(A1,V1), JA),
             arg_to_json(arg(A2,V2), JB)),
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
%   Lists all named audiences and their value orderings.
%
% GET /vaf/:audience
%   VAF preferred extensions for the named audience (Bench-Capon 2003).
%   Returns {"audience":"...","order":[...],"preferred":[...]}.
%
% GET /vaf/:audience/grounded
%   VAF grounded extension for the named audience.
%   Returns {"audience":"...","grounded":[...]}.
%
% All /vaf routes return 404 for an unrecognised audience name.
handle_vaf(Request) :-
    (   memberchk(path_info(PathInfo), Request),
        atom_concat('/', Rest, PathInfo),
        Rest \= ''
    ->  atomic_list_concat(Parts, '/', Rest),
        handle_vaf_path(Parts)
    ;   findall(json([audience=A, order=O]), audience(A, O), Auds),
        reply_json(Auds)
    ).

handle_vaf_path([Aud]) :-
    !,
    handle_vaf_audience(Aud).
handle_vaf_path([Aud, grounded]) :-
    !,
    handle_vaf_grounded(Aud).
handle_vaf_path(_) :-
    reply_json(json([error='not found']), [status(404)]).

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

handle_vaf_grounded(Aud) :-
    (   audience(Aud, _)
    ->  vaf_grounded_extension(Grounded, Aud),
        ext_json(Grounded, GroundedJSON),
        reply_json(json([
            audience = Aud,
            grounded = GroundedJSON
        ]))
    ;   reply_json(json([error='unknown audience', audience=Aud]), [status(404)])
    ).


% --- Helpers ---

% arg_json(+Ag, +Acts, +Val, -JSON) — argument with agent field.
% Action terms are converted to atoms so the JSON library can serialise them
% (joint actions like buyH-comC are compound terms that would otherwise
% cause a type error in reply_json).
arg_json(Ag, Acts, Val, json([agent=Ag, actions=ActAtoms, value=Val])) :-
    maplist(action_to_atom, Acts, ActAtoms).

% arg_json(+Ag, +Acts, +Val, +Scheme, -JSON) — argument with scheme field.
arg_json(Ag, Acts, Val, Scheme, json([agent=Ag, actions=ActAtoms, value=Val, scheme=Scheme])) :-
    maplist(action_to_atom, Acts, ActAtoms).

% action_to_atom(+Act, -Atom)
% Converts a joint-action compound H-C to the dash-separated atom 'H-C'.
% Plain atoms (individual actions) pass through unchanged.
action_to_atom(H-C, Atom) :-
    !,
    atomic_list_concat([H, C], '-', Atom).
action_to_atom(A, A).

% ext_json(+Ext, -JSON) converts a list of arg/2 terms to a JSON array.
% Extensions track only actions and value (agent is not stored in arg/2 terms).
ext_json(Ext, JSON) :-
    maplist(arg_to_json, Ext, JSON).

arg_to_json(arg(Acts, Val), json([actions=ActAtoms, value=Val])) :-
    maplist(action_to_atom, Acts, ActAtoms).
