simpleEPG
=========

Dreambox and Vu+ boxes EPG for iOS

This code compiles on Embarcadero Appmethod & Delphi XE5 (FireMonkey) and is primarily destined to run on iOS -
However it should run on Android devices too (not tested).

CJ

- NEW (HEAD, v0.8.2):

* Loading speed optimisations
* screen rotation blocked to portrait
* keyboard sometimes doesn't show up on settings -> restart app --> FIXED
* settings don't scroll up on small screens when typing         --> FIXED

- KNOWN BUGS


* timer deletion doesn't work correctly for more than 1 timer in the list
* Switching through channels via the combobox with "^" generates an error 
  when going back before the first channel (or beyond the last)


- TO DO (for v1.0):

* cleanups and bugfixes

- TO DO (for v1.1):

* implement progressbar for first EPG event
* implement Searchbox for channels and EPG events

