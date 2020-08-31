function eeg_init(infiles,outsetfile)

% Loop through infiles
for i=1:length(infiles);
    % Import egi file
    ALLEEG(i) = pop_readegi(infiles{i}, [],[],'auto');
end

% Merge files
EEG = pop_mergeset( ALLEEG, 1:length(ALLEEG), 0);

% Add Cz to data array
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


% Make sure each channel has the EEG type written in it for future BIDS
for i=1:length(EEG.chanlocs)
    EEG.chanlocs(i).type = 'eeg';
end

% Load standard montage
EEG = pop_chanedit(EEG, 'load',{'sourcedata/misc/GSN-HydroCel-129_EEGLAB.sfp' 'filetype' 'autodetect'});

% If the EEG event type is epoc, update it to boundary
if ~isempty(EEG.event);
    for i=1:length(EEG.event);
        if strcmp(EEG.event(i).type,'epoc');
            EEG.event(i).type='boundary';
        end
    end
end


% Save output set file
EEG = pop_saveset( EEG, 'filename',outsetfile);


