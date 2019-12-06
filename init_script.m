% This script searches sourcedata for mat files and converts them to set/fdt

myDir = [pwd '/sourcedata'];
myFiles = dir(fullfile(myDir,'*.mat')); %gets all wav files in struct
fileNames = {myFiles.name};

for f=1:length(fileNames)
    clear EEG;

    fullName = fullfile(myDir,fileNames{f});
    load(fullName);
    EEG=pop_chanedit(EEG, 'load',{'sourcedata/GSN_HydroCel_129.sfp' 'filetype' 'autodetect'});
    
    for i=1:length(EEG.event)
        EEG.event(i).type = strrep(EEG.event(i).type,' ','');
    end
    
    EEG.event = [];

    outName = strrep(fileNames{f},'.mat','.set');
    EEG = pop_saveset( EEG, 'filename',outName);
end