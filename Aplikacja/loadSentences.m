function [sentences] = loadSentences(fileName)
%Funkcja wczytująca zdania z pliku tekstowego

data=readtable(fileName);

sentences={};
data=table2array(data);

for i=1:length(data)
    
    oneSentence=strsplit(data{i}, ' ');
    oneSentence= oneSentence(3:end);
    sentences{i}=strcat(oneSentence{1:end});
    
end

end