[x,y] = system('find . -type f -name *.raw');
filenames = strsplit(y,'./');
filenames = filenames(3:end);
for i=1:length(filenames);
   eeg_init(EEG,filenames{i});
end
