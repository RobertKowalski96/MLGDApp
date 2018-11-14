function [grammar] = generateMaxGrammar(terminalsFile, nonTerminalsFile)

fileID = fopen(terminalsFile);
terminals=textscan(fileID,'%s');
terminals=terminals{1};

fileID = fopen(nonTerminalsFile);
nonTerminals=textscan(fileID,'%s');
nonTerminals=nonTerminals{1};

rules={};

for i=1:length(terminals)
    newRule{2}=terminals(i);
    
    for j=1:length(nonTerminals)
        newRule{1}=nonTerminals(j);
        
        newRule=[newRule{1}, newRule{2}];
        rules=vertcat(rules,newRule);
    end
    
end

for i=1:length(nonTerminals)
    newRule{1}=nonTerminals(i);
    for j=1:length(nonTerminals)
        newRule{2}=nonTerminals(i);
        for k=1:length(nonTerminals)
            newRule{2}=strcat(nonTerminals{j}, {' '}, nonTerminals{k});
            
            newRule=[newRule{1}, newRule{2}];
            rules=vertcat(rules,newRule);
        end
        
    end
    
end

rules=sortrows(rules,1);

grammar.rules=rules;

grammar.symbols=vertcat(rules(:,1),rules(:,2));
grammar.symbols=unique(grammar.symbols,'stable');





end