% array2range - Converts a typical 1xN array of numeric data into a range
%               style notation.
% Usage:
%    >> newRange = array2range(data,':');
%
% Required Inputs:
%    arrayIn  = 1xN array of numerica data.
%
%    delim    = Delimiter to be placed between ranges.
%
% Outputs:
%    outStr   = Formatted range as a string
%
% Example:
%    data = [1 2 3 4 5 6 10 11 12 13 14 15 300 301 302 303 500 901 902 903 904 905];
%    newRange = array2range(data,'-');
%    
%    newRange = [1-6 10-15 300-303 500 901-905]
%
% Written by:
%    Tyler K. Collins
%    BUCANL
%    Brock University

function outStr = array2range(arrayIn,delim)
markers = find(diff(arrayIn) ~= 1);
markers = [0 markers length(arrayIn)];

pairList = zeros(2,length(markers)/2);
for i=1:length(markers) - 1
    pairList(1,i) = arrayIn(markers(i) + 1);
    pairList(2,i) = arrayIn(markers(i+1));
end

outStr = '[';
for i=1:length(pairList)
   if pairList(1,i) == pairList (2,i)
       outStr = [outStr num2str(pairList(1,i)) ' '];
   else
       outStr = [outStr num2str(pairList(1,i)) delim num2str(pairList(2,i)) ' '];
   end
end
outStr = [outStr(1:end-1) ']'];
