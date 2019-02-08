function eeg_init(EEG,infname)

infile=load(infname);

EEG.srate=infile.samplingRate;
if isfield(infile,'Category_1');
    EEG.data=infile.Category_1;
else
    EEG.data=infile.Category_1_Segment1;
end

evt_count=0;
if isfield(infile,'ECI_TCPIP_55513');
    for i=1:size(infile.ECI_TCPIP_55513,2);
        evt_count=evt_count+1;
        EEG.event(evt_count).type=infile.ECI_TCPIP_55513{1,i};
        EEG.event(evt_count).latency=infile.ECI_TCPIP_55513{4,i};
    end
end
if isfield(infile,'EEG');
    for i=1:size(infile.EEG,2);
        evt_count=evt_count+1;
        EEG.event(evt_count).type=infile.EEG{1,i};
        EEG.event(evt_count).latency=infile.EEG{4,i};
    end
end
evt_count=[];

EEG.nbchan=size(EEG.data,1);

%parse infname.
[p,n]=fileparts(infname);
%subject ID
subids_ind=strfind(n,'ISP')+3;
subide_ind=strfind(n,'EEG')-1;
subid=n(subids_ind:subide_ind);
dots_ind=strfind(subid,'.');
if ~isempty(dots_ind);
    subid=subid(dots_ind(1)+1:dots_ind(2)-1);
end
%session ID 
sesids_ind=strfind(n,'EEG')+3;
seside_ind=strfind(n,'m.')-1;
sesid=n(sesids_ind:seside_ind);
dots_ind=strfind(sesid,'.');
if ~isempty(dots_ind);
    sesid=sesid(dots_ind(1)+1:end);
end
if length(sesid)==1;
    sesid=['0',sesid];
end

if ~isfield(EEG,'event');
    for i=1:length(EEG.event);
        if strcmp(EEG.event(i).type,'epoc');
            EEG.event(i).type='boundary';
        end
    end
end

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
