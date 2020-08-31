[x,y] = system('find . -type f -name *.bdf');
filenames = strsplit(y,'./');
filenames = sort(filenames(2:end));
for i=1:length(filenames)/2;
   eeg_init(EEG,{filenames{i},filenames{i+length(filenames)/2}});
end
