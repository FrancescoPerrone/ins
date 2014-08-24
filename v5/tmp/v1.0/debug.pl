/** File: debug.pl
-------------------------------------------------------------
This file is my debuggin frameworks.
It let's me load all files I need and also
strats pldoc servis at a given port.
This allows me to consult various documentation and brows
my own code.

This is just a temporary file...

@author Francesco Perrone

*/

% Starts the PlDoc services
% -------------------------------------------------------------

% Start PlDoc at port 3000
:- doc_server(3000).
% Start PlDoc at port 3000    
:- doc_collect(true).
:- portray_text(true).  

% File to test
% -------------------------------------------------------------
:- use_module(action). 
:- use_module(state).
:- use_module(trans).
:- use_module(value).

%:- use_module(jaction).  
