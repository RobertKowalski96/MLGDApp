function [population] = scaleRulesProb (grammar,population)

for i=1:length(population)
    rulesProb = population(i,:);
    for j=1:length(grammar.rules.connections)
        idx=cell2mat(grammar.rules.connections(j));
        sameSum=sum(rulesProb(idx));
        rulesProb(idx)=rulesProb(idx)/sameSum;
    end
    population(i,:) = rulesProb;
end

end

