:-module(trans, [trans/4]).

trans(Init, Ac, New, 0):-
    findAcs([doNoH], New),
    perform(Init, New, doNoH),


trans(Init, Ac, New, _):-
    perform(Init, Inter, Ac),
    trans(Inter, Rest, New, _).

findAcs(Acs, In):-
    bagof(Ac, Next^(perform(In, Next, Ac)), Acs).
