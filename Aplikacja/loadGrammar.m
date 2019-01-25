function[grammar] = loadGrammar(fileName)
%Funkcja wczytuj¹ca gramatykê z pliku tekstowego zawieraj¹cego jej regu³y

fileID = fopen(fileName);
grammarRow=textscan(fileID,'%s %s %s');

A=grammarRow{1};
B=grammarRow{2};
C=grammarRow{3};

grammar.nonTerminals=A;
grammar.nonTerminals=unique(grammar.nonTerminals,'stable');

grammar.rules.Lex={};
grammar.rules.NonLex={};

for i=1:length(A)
    if ~isempty(C{i})
        grammar.rules.NonLex(end+1,:)={A(i),B(i),C(i)};
    else
        grammar.rules.Lex(end+1,:)={A(i),B(i)};
    end
end

%mapowanie regu³ strukturalnych (zamiana symboli nieterminalnych na liczby)
for i=1:length(grammar.rules.NonLex)
    for j=1:length(grammar.rules.NonLex(1,:))
        grammar.rules.NonLex{i,j}=find(ismember(grammar.nonTerminals, grammar.rules.NonLex{i,j}));
    end
end

%mapowanie regu³ leksyklanych
for i=1:length(grammar.rules.Lex)
    grammar.rules.Lex{i,1}=find(ismember(grammar.nonTerminals, grammar.rules.Lex{i,1}));
end

%wyszukiwanie regu³ o tym samym poprzedniku
allRulesLeft=vertcat(grammar.rules.NonLex{:,1},grammar.rules.Lex{:,1});

grammar.rules.connections={};
for i=1:length(grammar.nonTerminals)
    sameRules=[];
    for r=1:length(allRulesLeft)
        if allRulesLeft(r)==i
            sameRules=[sameRules, r];
        end
    end
    grammar.rules.connections{end+1}=sameRules;
end


end
