%           File tested

:- use_module(states).
:- use_module(actions).
:- use_module(trans).
:- use_module(values).
:- use_module(args).
:- use_module(extensions).
:- use_module(vaf).


%           Starts the PlDoc services

:- doc_server(_).
:- doc_collect(true).
:- portray_text(true).


%           Tests

% 1. Enumerate all valid states
:- format("~n--- Valid states ---~n"),
   forall(state(S), format("state: ~w~n", [S])).

% 2. Show all initial states
:- format("~n--- Initial states ---~n"),
   forall(initial_state(S), format("initial: ~w~n", [S])).

% 3. Show all 1-step transitions from each initial state
:- format("~n--- 1-step transitions from initial states ---~n"),
   forall((initial_state(Init), perform(Init, Next, Act)),
          format("~w --[~w]--> ~w~n", [Init, Act, Next])).

% 4. Show all 2-step action sequences from initial states
:- format("~n--- 2-step transitions ---~n"),
   forall((initial_state(Init), trans(Init, Acts, Next, 2)),
          format("~w --~w--> ~w~n", [Init, Acts, Next])).

% 5. Evaluate state pairs for Hal
:- format("~n--- Value evaluations (hal) ---~n"),
   forall((initial_state(S1), perform(S1, S2, _),
           eval(hal, S1, S2, Eval)),
          format("~w -> ~w : ~w~n", [S1, S2, Eval])).

% 6. List all arguments
:- format("~n--- Arguments ---~n"),
   forall(arg(Acts, Val),
          format("arg(~w, ~w)~n", [Acts, Val])).

% 7. List all attacks between arguments
:- format("~n--- Attacks ---~n"),
   forall(attacks(A1, A2),
          format("~w attacks ~w~n", [A1, A2])).


% 8. Grounded extension
:- format("~n--- Grounded extension ---~n"),
   grounded_extension(Ext),
   format("grounded: ~w~n", [Ext]).

% 9. Preferred extensions
:- format("~n--- Preferred extensions ---~n"),
   forall(preferred_extension(Ext),
          format("preferred: ~w~n", [Ext])).

% 10. Stable extensions
:- format("~n--- Stable extensions ---~n"),
   forall(stable_extension(Ext),
          format("stable: ~w~n", [Ext])).


% 11. VAF defeats and preferred extensions per audience
:- format("~n--- VAF: defeats and preferred extensions by audience ---~n"),
   forall(audience(Aud, Order),
          (format("~naudience(~w): ~w~n", [Aud, Order]),
           format("  defeats:~n"),
           forall(defeats(A, B, Aud),
                  format("    ~w defeats ~w~n", [A, B])),
           format("  grounded: "),
           vaf_grounded_extension(GExt, Aud),
           format("~w~n", [GExt]),
           format("  preferred extensions:~n"),
           forall(vaf_preferred_extension(Ext, Aud),
                  format("    ~w~n", [Ext])))).


%           Listener

