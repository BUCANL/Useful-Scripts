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

start_inds = find(strcmpi('Rst0',{EEG.event.type}));
end_inds = find(strcmpi('Rst1',{EEG.event.type}));

if isempty(start_inds) || isempty(end_inds);
    disp('SKIPPING [batch_dfn]: no Rst0 or Rst1 markers in dataset.');
    return;
end;
if length(start_inds)~=length(end_inds);
    disp('SKIPPING [batch_dfn]: different number of Rst0 and Rst1 markers.');
    return;
end;
