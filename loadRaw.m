% Reload the raw
clear EEG;

load('/home/tyler/Documents/Qceeg19/sourcedata/egi/RestRaw.mat');
EEG=pop_chanedit(EEG, 'load',{'sourcedata/egi/GSN_HydroCel_129.sfp' 'filetype' 'autodetect'});

eeglab redraw
