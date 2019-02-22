%% staging script for segmenting washington resting data
  
EEG.group = '';
fid = fopen('washington_participants.csv','r');
rline = fgetl(fid);
while ischar(rline);
    splitline = strsplit(rline,',');
    subj = splitline{1};
    if strcmp(EEG.subject(1),'p');
        EEG.group = 'pilot';
        break;
    end;
    if strcmp(EEG.subject(2:end),subj);
        risk = splitline{2};
	    outcome = splitline{3};
	    EEG.gender = splitline{4};
	    if strcmp(risk,'LRC');
            if strcmp(outcome,'no_asd');
	            EEG.group = 'LRC-';
            elseif strcmp(outcome,'asd');
	            EEG.group = 'LRC+';
            elseif strcmp(outcome,'no_asd_18m');
                EEG.group = 'LRC-_18m';
                %EEG.group = 'LRC-';
            elseif strcmp(outcome,'unknown');
                EEG.group = 'LRC_UNK';
            end;
	    elseif strcmp(outcome,'no_asd');
	        EEG.group = 'HRA-';
	    elseif strcmp(outcome,'no_asd_18m');
	        EEG.group = 'HRA-_18m';
            %EEG.group = 'HRA-';
        elseif strcmp(outcome,'asd');
	        EEG.group = 'HRA+';
        elseif strcmp(outcome,'asd_18m');
	        EEG.group = 'HRA+_18m';
            %EEG.group = 'HRA+';
        elseif strcmp(outcome,'unknown');
            EEG.group = 'HRA_UNK';         
	    end;
        break;
    end;
    rline = fgetl(fid);
end;
fclose(fid);

socl_inds = find(strcmpi('Socl',{EEG.event.type}));
toys_inds = find(strcmpi('Toys',{EEG.event.type}));
endm_inds = find(strcmpi('EndM',{EEG.event.type}));

if length(socl_inds)==1;
    EEG.event(end+1).type = 'EndM';
    EEG.event(end).latency = EEG.pnts;
    endm_inds = find(strcmpi('EndM',{EEG.event.type}));
end;
if length(toys_inds)==1;
    EEG.event(end+1).type = 'EndM';
    EEG.event(end).latency = EEG.pnts;
    endm_inds = find(strcmpi('EndM',{EEG.event.type}));
end;

all_inds = sort(horzcat(socl_inds,toys_inds,endm_inds));
for i=1:length(all_inds);
    if ismember(all_inds(i),endm_inds);
        EEG.event(all_inds(i)).type = [EEG.event(all_inds(i-1)).type '_EndM'];
    end
end

EEG.event(socl_inds(2:2:end)) = [];
toys_inds = find(strcmpi('Toys',{EEG.event.type}));
EEG.event(toys_inds(2:2:end)) = [];
