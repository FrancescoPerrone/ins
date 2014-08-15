% file: ac.pl
:- module(ac, [actions/2]).

actions([buy, compensate, doNothing, lose, take]).

active_actions([buy, compensate, take, doNothing]).
passive_actions([doNothing]).

actions(carla, [buy, compensate, doNothing, lose, take]).
actions(hal, [buy, compensate, doNothing, lose, take]).
    
