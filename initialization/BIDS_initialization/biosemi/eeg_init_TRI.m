function eeg_init(inbdffiles,outsetfile)

% Loop through inbdffiles
for i=1:length(inbdffiles);
    %import bdf file
    EEG(i) = pop_biosig(inbdffiles{i}, 'channels', 1:135 );
end

% Load average BUCANL BioSemi head channel coordinates
EEG=pop_chanedit(EEG, 'load',{'sourcedata/misc/Biosemi_montage_attempt.sfp' 'filetype' 'autodetect'});

% Make sure each channel has the EEG type written in it for future BIDS
for i=1:length(EEG.chanlocs)
    EEG.chanlocs(i).type = 'eeg';
end

% Rename events
for i=1:length(EEG.event);
    if isnumeric(EEG.event(i).type);
        EEG.event(i).type=num2str(EEG.event(i).type);
    end
    if strcmp(EEG.event(i).type,'81');
        EEG.event(i).type='rst-cls-end';
    elseif strcmp(EEG.event(i).type,'80');
        EEG.event(i).type='rst-cls-strt';
    elseif strcmp(EEG.event(i).type,'71');
        EEG.event(i).type='rst-opn-end';
    elseif strcmp(EEG.event(i).type,'70');
        EEG.event(i).type='rst-opn-strt';
    elseif strcmp(EEG.event(i).type,'63');
        EEG.event(i).type='end-task';
    elseif strcmp(EEG.event(i).type,'30');
        EEG.event(i).type='fixation';
    elseif strcmp(EEG.event(i).type,'14');
        EEG.event(i).type='target';
    elseif strcmp(EEG.event(i).type,'13');
        EEG.event(i).type='nontarget';
    elseif strcmp(EEG.event(i).type,'11');
        EEG.event(i).type='prac-end';
    elseif strcmp(EEG.event(i).type,'10');
        EEG.event(i).type='prac-start';
    elseif strcmp(EEG.event(i).type,'9');
        EEG.event(i).type='rsp';
    elseif strcmp(EEG.event(i).type,'8');
        EEG.event(i).type='other';
    elseif strcmp(EEG.event(i).type,'7');
        EEG.event(i).type='daydreams';
    elseif strcmp(EEG.event(i).type,'6');
        EEG.event(i).type='personal-worries';
    elseif strcmp(EEG.event(i).type,'5');
        EEG.event(i).type='state-being';
    elseif strcmp(EEG.event(i).type,'4');
        EEG.event(i).type='everyday-things';
    elseif strcmp(EEG.event(i).type,'3');
        EEG.event(i).type='task-eval';
    elseif strcmp(EEG.event(i).type,'2');
        EEG.event(i).type='task-approach';
    elseif strcmp(EEG.event(i).type,'1');
        EEG.event(i).type='on-task';
    elseif strcmp(EEG.event(i).type,'boundary');
        EEG.event(i).duration=0;
    else
        EEG.event(i).type=['e-',num2str(EEG.event(i).type)];
    end
end

% Save output set file
EEG = pop_saveset( EEG, 'filename',outsetfile);

end
