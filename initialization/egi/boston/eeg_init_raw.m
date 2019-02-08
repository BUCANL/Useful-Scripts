function eeg_init_raw(EEG,infname)

disp(['current file: ', infname])

%parse infname.
[~,n]=fileparts(infname);

%subject ID
subid = n(4:7);
sesid = n(end-2:end-1);

EEG = pop_readegi(infname(1:end), [],[],'auto');

if ~isfield(EEG,'event');
    for i=1:length(EEG.event);
        if strcmp(EEG.event(i).type,'epoc');
            EEG.event(i).type='boundary';
        end
    end
end

if EEG.nbchan==64;
    EEG.data= vertcat(EEG.data,zeros(1,size(EEG.data,2)));
    EEG.nbchan=65;
elseif EEG.nbchan==128;
    EEG.data= vertcat(EEG.data,zeros(1,size(EEG.data,2)));
    EEG.nbchan=129;
end

EEG.urchanlocs = [];
EEG.urevent = [];
EEG = eeg_checkset(EEG);

if EEG.nbchan==65;
    EEG = pop_chanedit(EEG, 'load',{'sourcedata/misc/GSN65v2_0.sfp' 'filetype' 'autodetect'});
else
    EEG = pop_chanedit(EEG, 'load',{'sourcedata/misc/GSN-HydroCel-129_EEGLAB.sfp' 'filetype' 'autodetect'});
end

outfpath=['sub-s',subid,'/ses-m',sesid,'/eeg/'];
% CHECK FOR OUTPUT PATH AND CRETAE IF NECESSARY
if ~exist(outfpath);
    disp(['Making directory ', outfpath]);
    eval(['mkdir ' outfpath]);
end

outfname=['sub-s',subid,'_ses-m',sesid,'_task-rest_eeg.set'];

%save output set file
EEG = pop_saveset( EEG, 'filename',[outfpath,'/',outfname]);

