simpleEPG
=========

Dreambox and Vu+ boxes EPG for iOS

This code compiles on Embarcadero Appmethod & Delphi XE5 (FireMonkey) and is primarily destined to run on iOS -
However it should run on Android devices too (not tested).

CJ

- NEW (HEAD, v0.8.1):

* several robustness tests agains poor network conditions or wrong settings

- KNOWN BUGS

* keyboard sometimes doesn't show up on settings -> restart app
* timer deletion doesn't work correctly for more than 1 timer in the list
* settings don't scroll up on small screens when typing
* wrong splash screen on iPad in debug mode

- TO DO (for v1.0):

* cleanups and bugfixes

- TO DO (for v1.1):

* implement progressbar for first EPG event
* implement Searchbox for channels and EPG events

