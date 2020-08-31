in_source=dir('sourcedata/eeg/mat/new/*mat');
for i=1:length(in_source);
    eeg_init(EEG,['sourcedata/eeg/mat/new/',in_source(i).name]);
end

%in_source=dir('sourcedata/eeg/raw/*raw');
%for i=1:length(in_source);
%    eeg_init_raw(EEG,['sourcedata/eeg/raw/',in_source(i).name]);
%end