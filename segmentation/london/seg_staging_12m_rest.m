%% staging script for segmenting london 6m rest data

participants = tdfread('london_participants.tsv','\t');
p_ind = find(participants.participant_id==str2num(EEG.subject));

if strcmp(EEG.filename(6),'6');
    if participants.outcome(p_ind)==3;
        EEG.group = 'HRA+';
    else;
        EEG.group = 'HRA-';
    end;
else;
    EEG.group = 'LRC-';
end;

rest_inds = find(strcmpi('Rst0',{EEG.event.type}));
mov1_inds = find(strcmpi('mov1',{EEG.event.type}));
mov2_inds = find(strcmpi('mov2',{EEG.event.type}));
mov3_inds = find(strcmpi('mov3',{EEG.event.type}));
mov_inds = horzcat(mov1_inds,mov2_inds,mov3_inds);

if isempty(rest_inds);
    disp('SKIPPING [batch_dfn]: no Rst0 markers in dataset');
    return;
end;

end_inds = rest_inds+1;

eeg_inds = {};
for i=1:length(rest_inds);
    eeg_inds{i} = find(cell2mat({EEG.event.latency})==EEG.event(rest_inds(i)).latency);
    eeg_inds{i} = setdiff(eeg_inds{i},rest_inds);
    eeg_inds{i} = setdiff(eeg_inds{i},mov_inds);
end
eeg_inds = cell2mat(eeg_inds);

% eeg1: woman singing nursery rhymes/ peek-a-boo ('social')
% eeg2: brightly coloured toys moving and producing sounds ('non-social')
% eeg3: same toys manipulated by human hand ('semi-social')
for i=1:length(end_inds);
    EEG.event(end+1).type = [EEG.event(eeg_inds(i)).type '_off'];
    if EEG.event(end_inds(i)).latency>EEG.event(eeg_inds(i)).latency;
        EEG.event(end).latency = EEG.event(end_inds(i)).latency;
    elseif strcmp(EEG.event(eeg_inds(i)).type,'eeg1') && EEG.pnts - EEG.event(eeg_inds(i)).latency > 22187;
        EEG.event(end).latency = EEG.event(eeg_inds(i)).latency + 22187;
    elseif strcmp(EEG.event(eeg_inds(i)).type,'eeg2') && EEG.pnts - EEG.event(eeg_inds(i)).latency > 20987;
        EEG.event(end).latency = EEG.event(eeg_inds(i)).latency + 20987;
    elseif strcmp(EEG.event(eeg_inds(i)).type,'eeg3') && EEG.pnts - EEG.event(eeg_inds(i)).latency > 16248;
        EEG.event(end).latency = EEG.event(eeg_inds(i)).latency + 16248;        
    else;
        EEG.event(end).latency = EEG.pnts;
    end;
end    
