[x,y] = system('find ./sourcedata/eeg/raw/data/retry/temp/* -type f -name *.raw');
filenames = strsplit(y,'./');
filenames = filenames(2:end);
for i=1:length(filenames);
   eeg_init(EEG,[filenames{i} 'w']);
end
