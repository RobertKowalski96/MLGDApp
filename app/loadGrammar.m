function[grammar] = loadGrammar(fileName)

fileID = fopen(fileName);
grammarRow=textscan(fileID,'%s %s %s');

A=grammarRow{1};
B=grammarRow{2};
C=grammarRow{3};



for i=1:length(A)
    if ~isempty(C{i})
    B(i) = strcat(B{i}, {' '}, C{i});
    end

grammar.rules=[A,B];

grammar.symbols=vertcat(A,B);
grammar.symbols=unique(grammar.symbols,'stable');

end

