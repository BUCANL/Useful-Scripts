[x,y] = system('find ./sourcedata/eeg/raw/pilot_data/* -type f -name *.raw');
filenames = strsplit(y,'./');
filenames = filenames(2:end);
for i=1:length(filenames);
   eeg_init_pilot(EEG,[filenames{i} 'w']);
end
