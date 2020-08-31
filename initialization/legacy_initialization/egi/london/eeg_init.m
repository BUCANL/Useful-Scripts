function eeg_init(EEG,infname)

disp(['current file: ', infname(1:end)])

%parse infname.
[~,n]=fileparts(infname);
%subject ID
subid_ind = strfind(lower(n),lower('sib_'))+4;
subid=n(subid_ind:subid_ind+2);
agelab = 'm06';
if isempty(str2num(subid));
    subid_ind = strfind(lower(n),lower('sib_C'))+5;
    subid=n(subid_ind:subid_ind+2);
    agelab = 'm06';
end
if isempty(str2num(subid));
    subid_ind = strfind(lower(n),lower('sib2_'))+5;
    subid=n(subid_ind:subid_ind+2);
    agelab = 'm12';
end
if isempty(str2num(subid));
    subid_ind = strfind(lower(n),lower('sibC2_'))+6;
    subid=n(subid_ind:subid_ind+2);
    agelab = 'm12';
end

%group = 'at-risk'
%if strfind(n,'C');
%    group = 'control';
%end

outfpath=['sub-s',subid,'/ses-',agelab,'/eeg/'];
disp(['outpath: ', outfpath]);
disp(['current subid: ' subid]);

    
EEG = pop_readegi(infname(1:end-1), [],[],'auto');

%ADD Cz TO DATA ARRAY.
EEG.data(129,:)=zeros(size(EEG.data(1,:)));
EEG.nbchan=129;
EEG.chanlocs(129)=EEG.chanlocs(128);
EEG.chanlocs(129).labels=EEG.chaninfo.nodatchans(4).labels;
EEG.chanlocs(129).Y=EEG.chaninfo.nodatchans(4).Y;
EEG.chanlocs(129).X=EEG.chaninfo.nodatchans(4).X;
EEG.chanlocs(129).Z=EEG.chaninfo.nodatchans(4).Z;
EEG.chanlocs(129).sph_theta=EEG.chaninfo.nodatchans(4).sph_theta;
EEG.chanlocs(129).sph_phi=EEG.chaninfo.nodatchans(4).sph_phi;
EEG.chanlocs(129).sph_radius=EEG.chaninfo.nodatchans(4).sph_radius;
EEG.chanlocs(129).theta=EEG.chaninfo.nodatchans(4).theta;
EEG.chanlocs(129).radius=EEG.chaninfo.nodatchans(4).radius;
EEG.chanlocs(129).type='EEG';
EEG.chaninfo.nodatchans=EEG.chaninfo.nodatchans(1:3);

EEG = pop_chanedit(EEG, 'load',{'sourcedata/misc/GSN-HydroCel-129_EEGLAB.sfp' 'filetype' 'autodetect'});

% CHECK FOR OUTPUT PATH AND CRETAE IF NECESSARY
if ~exist(outfpath);
    disp(['Making directory ', outfpath]);
    eval(['mkdir ' outfpath]);
end

outfname=['sub-s',subid,'_ses-',agelab,'_eeg.set'];

disp(outfname);

%save output set file
EEG = pop_saveset( EEG, 'filename',[outfpath,'/',outfname]);
end

