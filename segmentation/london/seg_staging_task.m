%% staging script for segmenting london task data

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
