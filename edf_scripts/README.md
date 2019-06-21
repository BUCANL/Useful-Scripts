# EDF Helpers
Currently these scripts work on our personal version of EEGLAB that we use in the lab.

Namely, 13.6.5b.

## Current Behaviour
Exporting works totally as expected.

Importing the data files works fine - but channel information is lost as part of the export. Simply editing the chanlocs structure to have the proper information returns the file to the previous state.
