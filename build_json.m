% This script searches sourcedata for set/fdt files and makes a json file

myDir = [pwd '/sourcedata'];
myFiles = dir(fullfile(myDir,'*.set')); %gets all wav files in struct
fileNames = {myFiles.name};

outStr = sprintf('{\n"dataStruct" : [');

for f=1:length(fileNames)
    fullName = ['sourcedata/' fileNames{f}];
    
    outStr = sprintf('%s\n{\n"file" : ["%s"],\n',outStr,fullName);
    outStr = sprintf('%s"session" : 1,\n',outStr);
    outStr = sprintf('%s"run" : 1,\n',outStr);
    outStr = sprintf('%s"subID" : "%s"\n},',outStr,fileNames{f}(1:end-4));
    
end

outStr = outStr(1:end - 1);
outStr = sprintf('%s\n]\n}\n',outStr);

fileID = fopen('sourcedata/allData.json','w');
fprintf(fileID,'%s',outStr);
fclose(fileID);