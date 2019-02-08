function eeg_init(ALLEEG,in_bdffiles)

%loop through inbdffiles
for i=1:length(in_bdffiles)
    ALLEEG(i) = pop_biosig(in_bdffiles{i},'channels',1:135);

    [fpath,fname,ext] = fileparts(in_bdffiles{i});

    fparts = strsplit(fname,'_');

    task = lower(fparts{2});
    subj = num2str(fparts{3});

    if length(subj)<3;
        for j=1:3-length(subj);
            subj = ['0' subj];
        end;
    end;

    %rename events
    for j=1:length(ALLEEG(i).event);
        if isnumeric(ALLEEG(i).event(j).type);
            ALLEEG(i).event(j).type=num2str(ALLEEG(i).event(j).type);
        end
        if strcmp(ALLEEG(i).event(j).type,'11');
            ALLEEG(i).event(j).type=[task '_rl_1'];
        elseif strcmp(ALLEEG(i).event(j).type,'12');
            ALLEEG(i).event(j).type=[task '_rl_2'];
        elseif strcmp(ALLEEG(i).event(j).type,'21');
            ALLEEG(i).event(j).type=[task '_rnl_1'];
        elseif strcmp(ALLEEG(i).event(j).type,'22');
            ALLEEG(i).event(j).type=[task '_rnl_2'];
        elseif strcmp(ALLEEG(i).event(j).type,'31');
            ALLEEG(i).event(j).type=[task '_nrl_1'];
        elseif strcmp(ALLEEG(i).event(j).type,'32');
            ALLEEG(i).event(j).type=[task '_nrl_2'];
        elseif strcmp(ALLEEG(i).event(j).type,'41');
            ALLEEG(i).event(j).type=[task '_nrnl_1'];
        elseif strcmp(ALLEEG(i).event(j).type,'42');
            ALLEEG(i).event(j).type=[task '_nrnl_2'];
        elseif strcmp(ALLEEG(i).event(j).type,'205');
            ALLEEG(i).event(j).type=[task '_corr'];
        elseif strcmp(ALLEEG(i).event(j).type,'206');
            ALLEEG(i).event(j).type=[task '_inco'];
        elseif strcmp(ALLEEG(i).event(j).type,'210');
            ALLEEG(i).event(j).type='fix';
        elseif strcmp(ALLEEG(i).event(j).type,'211');
            ALLEEG(i).event(j).type='prac_1';
        elseif strcmp(ALLEEG(i).event(j).type,'212');
            ALLEEG(i).event(j).type='prac_2';
        elseif strcmp(ALLEEG(i).event(j).type,'255');
            ALLEEG(i).event(j).type='boundary';
        elseif strcmp(ALLEEG(i).event(j).type,'boundary');
            ALLEEG(i).event(j).duration=0;
        end
    end

end

%merge files
EEG = pop_mergeset(ALLEEG,1:length(ALLEEG), 0);

%resample to 512
EEG = pop_resample(EEG,512);

%load average BUCANL BioSemi head channel coordinates
EEG = pop_chanedit(EEG, 'load',{'code/misc/BioSemi_BUCANL_7Eyes_words_collide.sfp' 'filetype' 'autodetect'},'nfids',3);

out_setpath = ['sub-s' subj '/ses-01/eeg/'];
out_setfile = [out_setpath 'sub-s' subj '_ses-01_eeg.set'];

if ~exist(out_setpath);
    disp(['Making directory ', out_setpath]);
    eval(['mkdir ' out_setpath]);
end

%save output set file
disp(['Saving ' out_setfile '...']);
EEG = pop_saveset(EEG,'filename',out_setfile);

