simpleEPG
=========

Dreambox and Vu+ boxes EPG for iOS7

This code compiles on Embarcadero Appmethod & Delphi XE5/XE6 (FireMonkey) and is primarily destined to run on iOS7 -
However it should run on Android devices too (not tested).

CJ

NEW (HEAD, v0.9.0-beta):
------------------------

* timer deletion doesn't work correctly for more than 1 timer in the list --> FIXED
* Switching through channels via the combobox with "^" generates an error when going back before the first channel (or beyond the last)--> FIXED

* change in channel via combobox now updates the selection on
  main channel list too


KNOWN BUGS
----------

* argument out of range error when deleting last of more than 1 timers. Timer is still deleted correctly


TO DO (for v1.0):
-----------------

* cleanups and bugfixes

TO DO (for v1.1):
-----------------

* implement progressbar for first EPG event
* implement Searchbox for channels and EPG events

TO DO (for v2.0):
-----------------

* Graphical Multi-EPG

